#encoding=UTF-8
class HzpBsbsController < ApplicationController
    before_filter :init
    def init
        if current_user.is_admin?
            @admin_user=1
            else
            @admin_user=0
        end
        @avala=[2,12,15,16,27,29,32,40,49,57,70]
        @options=[]
        @avala.each do |i|
            @options[i]=Flexcontent.find_all_by_flex_field("hzp_bsb_hzp_s_#{i}",:order=>"flex_sortid ASC")
            @options[i]=@options[i].map{|option|[option[:flex_name],option[:flex_id]]}
        end
        
        
    end

  # GET /hzp_bsbs
  # GET /hzp_bsbs.json
  def index
      @ending_time=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
      @begin_time=(Time.now-2592000).year.to_s+'-'+(Time.now-2592000).mon.to_s+'-'+(Time.now-2592000).day.to_s
      if current_user.is_admin?          
          @hzp_bsbs= HzpBsb.paginate(:page=>params[:page],:order=>'hzp_d_90 DESC,hzp_s_14',:per_page=> 10)
          
          
          #@hzp_bsbs_all=HzpBsb.find_by_sql("select hzp_bsbs.hzp_s_54 from hzp_bsbs")
          
    else
          @hzp_bsbs = HzpBsb.paginate(:page=>params[:page],:conditions=>["hzp_s_3=?",session[:user_province]],:order=>'hzp_d_90 DESC,hzp_s_14',:per_page=> 10)
      end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hzp_bsbs }
    end
  end

  # GET /hzp_bsbs/1
  # GET /hzp_bsbs/1.json
  def show
    @hzp_bsb = HzpBsb.find(params[:id])
    @hzp_data=Hzpdatum.find_all_by_hzp_bsb_id(params[:id])
    @hzp_jcxcount=@hzp_bsb.hzp_n_jcxcount
    if @hzp_jcxcount==nil
        @hzp_jcxcount=1
    end
  end

  # GET /hzp_bsbs/new
  # GET /hzp_bsbs/new.json
  def new
      @hzp_jcxcount=1
      @hzp_bsb = HzpBsb.new
      @hzp_bsb.hzp_s_89=session[:user_tname]
      @hzp_bsb.hzp_s_31=session[:user_company]
      @hzp_bsb.tname=session[:user_name]
      @hzp_bsb.hzp_s_33=session[:user_tname]
      @hzp_bsb.hzp_s_36=session[:user_name]
      @hzp_bsb.hzp_s_37=session[:user_tel]
      @hzp_bsb.hzp_s_38=session[:user_mail]
      @hzp_bsb.hzp_i_state=0;
      @hzp_bsb.hzp_d_90=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hzp_bsb }
    end
  end

  # GET /hzp_bsbs/1/edit
  def edit
    @hzp_bsb = HzpBsb.find(params[:id])
    @hzp_data=Hzpdatum.find_all_by_hzp_bsb_id(params[:id])
    @hzp_jcxcount=@hzp_bsb.hzp_n_jcxcount
    if @hzp_jcxcount==nil
        @hzp_jcxcount=1
    end
  end

  # POST /hzp_bsbs
  # POST /hzp_bsbs.json
  def create
      @hzp_bsb = HzpBsb.new(params[:hzp_bsb])
      @hzp_bsb.tname=session[:user_name]
      result_record=HzpBsb.find(:first, :conditions => [ "hzp_s_14=?",params[:hzp_bsb][:hzp_s_14]])
      
      
      respond_to do |format|
          ActiveRecord::Base.transaction do
              if result_record!=nil
                  flash[:import_result] = "保存不成功，数据库中已有该样品编号!"
                  format.html { render action: "new" }
              else
                  if @hzp_bsb.save
                      params[:hzpdata].each do |data|
                          data.delete(:id)
                          data[:hzp_bsb_id] = @hzp_bsb.id
                          Hzpdatum.create!(data)
                      end
                      format.html { redirect_to(:action => "index",:controller=>"hzp_bsbs") }
                      format.json { render json: @hzp_bsb, status: :created, location: @hzp_bsb }
                  else
                      format.html { render action: "new" }
                      format.json { render json: @hzp_bsb.errors, status: :unprocessable_entity }
                  end
              end
          end
      end
  end

  # PUT /hzp_bsbs/1
  # PUT /hzp_bsbs/1.json
  def update
    @hzp_bsb = HzpBsb.find(params[:id])
    result_record=HzpBsb.find(:first, :conditions => [ "hzp_s_14=?",params[:hzp_bsb][:hzp_s_14]])
    if (@hzp_bsb.hzp_s_14==params[:hzp_bsb][:hzp_s_14])||(result_record==nil)
        respond_to do |format|
            ActiveRecord::Base.transaction do
                if @hzp_bsb.update_attributes(params[:hzp_bsb])
                    @hzp_bsb.hzpdata.destroy_all
                        params[:hzpdata].each do |data|
                            data.delete(:id)
                            data[:hzp_bsb_id] = params[:id]
                            Hzpdatum.create!(data)
                        end
                    format.html { redirect_to(:action => "index",:controller=>"hzp_bsbs") }
                    format.json { head :no_content }
                else
                    format.html { render action: "edit" }
                    format.json { render json: @hzp_bsb.errors, status: :unprocessable_entity }
                end
            end
        end
    else
        respond_to do |format|
            flash[:import_result] ="修改不成功，数据库中已有该样品编号!"
            @temp_hzp_bsb = HzpBsb.find(params[:id])
            params[:hzp_bsb][:hzp_s_14]=@temp_hzp_bsb.hzp_s_14#改回原编号，更新内容不变
            @hzp_bsb=HzpBsb.new(params[:hzp_bsb])
            @hzp_data=params[:hzpdata]
            format.html { redirect_to :action => "edit", :id => params[:id] }
        end
    end
  end

  # DELETE /hzp_bsbs/1
  # DELETE /hzp_bsbs/1.json
  def destroy
    @hzp_bsb = HzpBsb.find(params[:id])
    @hzp_bsb.destroy

    respond_to do |format|
      format.html { redirect_to hzp_bsbs_url }
      format.json { head :no_content }
    end
  end
    
    # POST /hzp_bsbs/spsearch
    # POST /hzp_bsbs/spsearch.json
    def spsearch
        str="hzp_d_90>=? and hzp_d_90<=?"
        if params[:begin_time]
            @begin_time=params[:begin_time]
        end
        if params[:ending_time]
            @ending_time=params[:ending_time]
        end
        if params[:s1]!=''#采样单位
            str=str+" and hzp_s_31 like ?"
            @s1=params[:s1]
            @s1='%'+@s1+'%'
        else
            str=str+" and (hzp_s_31 is null or hzp_s_31 like ?)"
            @s1='%%'
        end
        if params[:s2]!=''#检验机构
            str=str+" and hzp_s_39 like ?"
            @s2=params[:s2]
            @s2='%'+@s2+'%'
        else
            str=str+" and (hzp_s_39 is null or hzp_s_39 like ?)"
            @s2='%%'
        end
        if params[:s3]!=''#填报人
            str=str+" and hzp_s_89 like ?"
            @s3=params[:s3]
            @s3='%'+@s3+'%'
        else
            str=str+" and (hzp_s_89 is null or hzp_s_89 like ?)"
            @s3='%%'
        end
        if params[:s4]!=''#样品名称
            str=str+" and hzp_s_13 like ?"
            @s4=params[:s4]
            @s4='%'+@s4+'%'
        else
            str=str+" and (hzp_s_13 is null or hzp_s_13 like ?)"
            @s4='%%'
        end
        if params[:s7]!=''#采样编号
            str=str+" and hzp_s_14 like ?"
            @s7=params[:s7]
            @s7='%'+@s7+'%'
            else
            str=str+" and (hzp_s_14 is null or hzp_s_14 like ?)"
            @s7='%%'
        end
        str=str+" and hzp_i_state>=? and hzp_i_state<=?"
        if params[:s8]
            @s8=params[:s8]
            if @s8=='2'
                @s8=2
                @s9=3
            end
            if @s8=='3'
                @s8=3
                @s9=4
            end
            if @s8=='1'
                @s8=0
                @s9=1
            end
            if @s8=='4'
                @s8=0
                @s9=10
            end
            if @s8=='5'
                @s8=10
                @s9=10
            end
        end
        
        if current_user.is_admin?
            @hzp_bsbs = HzpBsb.paginate(:page=>params[:page],:order=>'hzp_d_90 DESC',:per_page=> 10,:conditions=>[str,@begin_time,@ending_time,@s1,@s2,@s3,@s4,@s7,@s8,@s9])
            else
            @hzp_bsbs = HzpBsb.paginate(:page=>params[:page],:order=>'hzp_d_90 DESC',:per_page=> 10,:conditions=>["hzp_s_3=? and "+str,session[:user_province],@begin_time,@ending_time,@s1,@s2,@s3,@s4,@s7,@s8,@s9])
        end
        
        respond_to do |format|
            format.html { render action: "index"}
            format.json { render json: @hzp_bsbs }
        end
    end
    # get /hzp_bsbs/submit
    def submit
        if current_user.is_admin?
            @hzp_bsb = HzpBsb.find(params[:id])
            @hzp_bsb.update_attribute(:hzp_i_state,1)
        end
        respond_to do |format|
            format.html { redirect_to(:action => "index",:controller=>"hzp_bsbs") }
        end        
    end
    def import_excel
        uploaded_io = params[:excel]
        
        accepted_formats = [".xls", ".xlsx"]
        if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
            File.open(Rails.root.join('excel', uploaded_io.original_filename), 'wb') do |file|
                file.write(uploaded_io.read)
                
                book = Spreadsheet.open(Rails.root.join('excel', uploaded_io.original_filename))
                sheet1 = book.worksheet 0
                i_num=0
                sheet1.each do |row|
                    if i_num<=0
                        i_num=i_num+1
                        elsif (session[:user_province]==row[3])||(current_user.is_admin?&&row[3]!=nil)
                        
                        result_record=HzpBsb.find(:first, :conditions => [ "hzp_s_3 = ? and hzp_s_14=?",row[3],row[14]])
                        if result_record==nil&&row[14]!=nil
                            @bsb = HzpBsb.new
                            @bsb.hzp_s_70=row[0]
                            @bsb.hzp_s_1=row[1]
                            @bsb.hzp_s_2=row[2]
                            @bsb.hzp_s_3=row[3]
                            @bsb.hzp_s_4=row[4]
                            @bsb.hzp_s_5=row[5]
                            @bsb.hzp_s_12=row[6]
                            @bsb.hzp_s_6=row[7]
                            @bsb.hzp_s_9=row[8]
                            @bsb.hzp_s_7=row[9]
                            @bsb.hzp_s_8=row[10]
                            @bsb.hzp_s_10=row[11]
                            @bsb.hzp_s_11=row[12]
                            @bsb.hzp_s_13=row[13]
                            @bsb.hzp_s_14=row[14]
                            @bsb.hzp_s_15=row[15]
                            @bsb.hzp_s_16=row[16]
                            @bsb.hzp_s_17=row[17]
                            @bsb.hzp_s_18=row[18]
                            @bsb.hzp_s_19=row[19]
                            @bsb.hzp_d_20=row[20]
                            @bsb.hzp_s_22=row[21]
                            @bsb.hzp_s_23=row[22]
                            @bsb.hzp_s_61=row[23]
                            @bsb.hzp_s_62=row[24]
                            @bsb.hzp_s_24=row[25]
                            @bsb.hzp_s_25=row[26]
                            @bsb.hzp_s_63=row[27]
                            @bsb.hzp_n_26=row[28]
                            @bsb.hzp_s_27=row[29]
                            @bsb.hzp_n_28=row[30]
                            @bsb.hzp_s_29=row[31]
                            @bsb.hzp_s_30=row[32]
                            @bsb.hzp_s_31=row[33]
                            @bsb.hzp_s_32=row[34]
                            @bsb.hzp_s_33=row[35]
                            @bsb.hzp_d_34=row[36]
                            @bsb.hzp_s_35=row[37]
                            @bsb.hzp_s_36=row[38]
                            @bsb.hzp_s_37=row[39]
                            @bsb.hzp_s_38=row[40]
                            @bsb.tname=session[:user_name]
                            @bsb.hzp_s_89="#{session[:user_name]}批量导入"
                            @bsb.hzp_i_state=10
                            @bsb.hzp_n_jcxcount=1
                            @bsb.hzp_d_90=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
                            @bsb.save
                            i_num=i_num+1
                        end
                    end
                end
                flash[:import_result] = "文件上传成功,导入#{i_num-1}条记录!"
            end
            
            
            
            
            else
            flash[:import_result] = "文件上传失败！"
        end
        respond_to do |format|
            format.html {redirect_to :action => "index",:controller=>"hzp_bsbs" }
        end
    end
    def export_excel
        if current_user.is_admin?
            
            @hzp_bsbs= HzpBsb.all(:limit=>5,:order=>'hzp_d_90 DESC')
            
            else
            @hzp_bsbs = HzpBsb.all(:limit=>5,:conditions=>["hzp_s_3=?",session[:user_province]],:order=>'hzp_d_90 DESC')
            
        end
        book = Spreadsheet::Workbook.new
        sheet =book.create_worksheet :name=>"totles"
        
        sheet.row(0).concat %w{报送分类* 被采样单位名称* 单位类型* 省(市、自治区) 地区(市、州、盟) 县(市、区) 地域类型* 单位地址 邮编 被采样单位法人（负责人） 电话 被采样单位负责（联系）人* 电话* 样品名称* 抽样编号* 样品分类* 样品类别* 包装规格* 批号* 保质期/限用日期* 生产日期* 批准文号/备案号* 卫生许可证号* 进口国/产地（省）* 化妆品品牌* 标识生产企业名称* 标识生产企业地址* 委托生产企业名称* 采样数量* 数量单位* 货物数量 货物数量单位 备注 采样单位名称* 单位类型* 抽样人员* 抽样时间* 电话 采样单位负责（联系）人* 电话* 电子邮箱*}
        count_row=1
        @hzp_bsbs.each do |bsb|
            sheet[count_row,0]=bsb.hzp_s_70
            sheet[count_row,1]=bsb.hzp_s_1
            sheet[count_row,2]=bsb.hzp_s_2
            sheet[count_row,3]=bsb.hzp_s_3
            sheet[count_row,4]=bsb.hzp_s_4
            sheet[count_row,5]=bsb.hzp_s_5
            sheet[count_row,6]=bsb.hzp_s_12
            sheet[count_row,7]=bsb.hzp_s_6
            sheet[count_row,8]=bsb.hzp_s_9
            sheet[count_row,9]=bsb.hzp_s_7
            sheet[count_row,10]=bsb.hzp_s_8
            sheet[count_row,11]=bsb.hzp_s_10
            sheet[count_row,12]=bsb.hzp_s_11
            sheet[count_row,13]=bsb.hzp_s_13
            sheet[count_row,14]=bsb.hzp_s_14
            sheet[count_row,15]=bsb.hzp_s_15
            sheet[count_row,16]=bsb.hzp_s_16
            sheet[count_row,17]=bsb.hzp_s_17
            sheet[count_row,18]=bsb.hzp_s_18
            sheet[count_row,19]=bsb.hzp_s_19
            sheet[count_row,20]=bsb.hzp_d_20
            sheet[count_row,21]=bsb.hzp_s_22
            sheet[count_row,22]=bsb.hzp_s_23
            sheet[count_row,23]=bsb.hzp_s_61
            sheet[count_row,24]=bsb.hzp_s_62
            sheet[count_row,25]=bsb.hzp_s_24
            sheet[count_row,26]=bsb.hzp_s_25
            sheet[count_row,27]=bsb.hzp_s_63
            sheet[count_row,28]=bsb.hzp_n_26
            sheet[count_row,29]=bsb.hzp_s_27
            sheet[count_row,30]=bsb.hzp_n_28
            sheet[count_row,31]=bsb.hzp_s_29
            sheet[count_row,32]=bsb.hzp_s_30
            sheet[count_row,33]=bsb.hzp_s_31
            sheet[count_row,34]=bsb.hzp_s_32
            sheet[count_row,35]=bsb.hzp_s_33
            sheet[count_row,36]=bsb.hzp_d_34
            sheet[count_row,37]=bsb.hzp_s_35
            sheet[count_row,38]=bsb.hzp_s_36
            sheet[count_row,39]=bsb.hzp_s_37
            sheet[count_row,40]=bsb.hzp_s_38
            count_row += 1
        end
        savetempfile="public/#{session[:user_name]}#{(Time.now).to_s}hzp_template.xls"
        book.write(savetempfile)
        send_file(savetempfile,:disposition => "attachment")
    end
    def export_info_excel
        if current_user.is_admin?
            
            @hzp_bsbs= HzpBsb.all(:order=>'hzp_d_90 DESC')
            
            else
            @hzp_bsbs = HzpBsb.all(:conditions=>["hzp_s_3=?",session[:user_province]],:order=>'hzp_d_90 DESC')
            
        end
        book = Spreadsheet::Workbook.new
        sheet =book.create_worksheet :name=>"totles"
        
        sheet.row(0).concat %w{报送分类* 被采样单位名称* 单位类型* 省(市、自治区) 地区(市、州、盟) 县(市、区) 地域类型* 单位地址 邮编 被采样单位法人（负责人） 电话 被采样单位负责（联系）人* 电话* 样品名称* 抽样编号* 样品分类* 样品类别* 包装规格* 批号* 保质期/限用日期* 生产日期* 批准文号/备案号* 卫生许可证号* 进口国/产地（省）* 化妆品品牌* 标识生产企业名称* 标识生产企业地址* 委托生产企业名称* 采样数量* 数量单位* 货物数量 货物数量单位 备注 采样单位名称* 单位类型* 抽样人员* 抽样时间* 电话 采样单位负责（联系）人* 电话* 电子邮箱*}
        count_row=1
        @hzp_bsbs.each do |bsb|
            sheet[count_row,0]=bsb.hzp_s_70
            sheet[count_row,1]=bsb.hzp_s_1
            sheet[count_row,2]=bsb.hzp_s_2
            sheet[count_row,3]=bsb.hzp_s_3
            sheet[count_row,4]=bsb.hzp_s_4
            sheet[count_row,5]=bsb.hzp_s_5
            sheet[count_row,6]=bsb.hzp_s_12
            sheet[count_row,7]=bsb.hzp_s_6
            sheet[count_row,8]=bsb.hzp_s_9
            sheet[count_row,9]=bsb.hzp_s_7
            sheet[count_row,10]=bsb.hzp_s_8
            sheet[count_row,11]=bsb.hzp_s_10
            sheet[count_row,12]=bsb.hzp_s_11
            sheet[count_row,13]=bsb.hzp_s_13
            sheet[count_row,14]=bsb.hzp_s_14
            sheet[count_row,15]=bsb.hzp_s_15
            sheet[count_row,16]=bsb.hzp_s_16
            sheet[count_row,17]=bsb.hzp_s_17
            sheet[count_row,18]=bsb.hzp_s_18
            sheet[count_row,19]=bsb.hzp_s_19
            sheet[count_row,20]=bsb.hzp_d_20
            sheet[count_row,21]=bsb.hzp_s_22
            sheet[count_row,22]=bsb.hzp_s_23
            sheet[count_row,23]=bsb.hzp_s_61
            sheet[count_row,24]=bsb.hzp_s_62
            sheet[count_row,25]=bsb.hzp_s_24
            sheet[count_row,26]=bsb.hzp_s_25
            sheet[count_row,27]=bsb.hzp_s_63
            sheet[count_row,28]=bsb.hzp_n_26
            sheet[count_row,29]=bsb.hzp_s_27
            sheet[count_row,30]=bsb.hzp_n_28
            sheet[count_row,31]=bsb.hzp_s_29
            sheet[count_row,32]=bsb.hzp_s_30
            sheet[count_row,33]=bsb.hzp_s_31
            sheet[count_row,34]=bsb.hzp_s_32
            sheet[count_row,35]=bsb.hzp_s_33
            sheet[count_row,36]=bsb.hzp_d_34
            sheet[count_row,37]=bsb.hzp_s_35
            sheet[count_row,38]=bsb.hzp_s_36
            sheet[count_row,39]=bsb.hzp_s_37
            sheet[count_row,40]=bsb.hzp_s_38
            count_row += 1
        end
        savetempfile="public/#{session[:user_name]}#{(Time.now).to_s}化妆品样品信息.xls"
        book.write(savetempfile)
        send_file(savetempfile,:disposition => "attachment")
    end
    ###导入化妆品检测项标准
    def import_hzp_standards
        uploaded_io = params[:excel]
        accepted_formats = [".xls", ".xlsx"]
        if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
            File.open(Rails.root.join('excel', session[:user_name]+(Time.now).to_s+uploaded_io.original_filename), 'wb') do |file|
                file.write(uploaded_io.read)
                sta_f=File.new(File.join("app/assets/javascripts/hzpdata.js"), "w+")
                #f.puts("I am Jack")
                #f.puts("Hello World")
                book = Spreadsheet.open(Rails.root.join('excel',session[:user_name]+(Time.now).to_s+uploaded_io.original_filename))
                sheet1 = book.worksheet 0
                i_num=0
                temp_str='var HZPDL=['
                temp_str_2='var HZPXL=['
                temp_str_4='var HZPJCX=['
                temp_str_5='var HZPJCDW=['
                temp_str_6='var HZPJCYJ=['
                temp_str_7='var HZPPDYJ=['
                temp_str_8='var HZPPDZ=['
                flag_1=0;
                flag_2=0;
                flag_4=0;
                ActiveRecord::Base.transaction do
                    sheet1.each_with_index do |row,index|
                        if i_num<=0
                            i_num=i_num+1
                        elsif current_user.is_admin?
                            if row[0]
                                if flag_1==1
                                    temp_str=temp_str+","
                                    temp_str_2=temp_str_2+"],"
                                    temp_str_4=temp_str_4+"]],"
                                    temp_str_5=temp_str_5+"]],"
                                    temp_str_6=temp_str_6+"]],"
                                    temp_str_7=temp_str_7+"]],"
                                    temp_str_8=temp_str_8+"]],"
                                end
                                flag_1=1
                                temp_str=temp_str+"'"+"#{row[0]}".strip+"'"
                                temp_str_2=temp_str_2+"['"+"#{row[2]}".strip+"'"
                                temp_str_4=temp_str_4+"[['"+"#{row[4]}".strip+"'"
                                temp_str_5=temp_str_5+"[['"+"#{row[5]}".strip+"'"
                                temp_str_6=temp_str_6+"[['"+"#{row[6]}".strip+"'"
                                temp_str_7=temp_str_7+"[['"+"#{row[7]}".strip+"'"
                                temp_str_8=temp_str_8+"[['"+"#{row[8]}".strip+"'"
                            elsif row[2]
                                temp_str_4=temp_str_4+"],["
                                temp_str_5=temp_str_5+"],["
                                temp_str_6=temp_str_6+"],["
                                temp_str_7=temp_str_7+"],["
                                temp_str_8=temp_str_8+"],["
                                temp_str_2=temp_str_2+","
                                temp_str_2=temp_str_2+"'"+"#{row[2]}".strip+"'"
                                temp_str_4=temp_str_4+"'"+"#{row[4]}".strip+"'"
                                temp_str_5=temp_str_5+"'"+"#{row[5]}".strip+"'"
                                temp_str_6=temp_str_6+"'"+"#{row[6]}".strip+"'"
                                temp_str_7=temp_str_7+"'"+"#{row[7]}".strip+"'"
                                temp_str_8=temp_str_8+"'"+"#{row[8]}".strip+"'"
                            elsif row[4]
    
                                temp_str_4=temp_str_4+","
                                temp_str_5=temp_str_5+","
                                temp_str_6=temp_str_6+","
                                temp_str_7=temp_str_7+","
                                temp_str_8=temp_str_8+","
                                
                                flag_4=1
                                temp_str_4=temp_str_4+"'"+"#{row[4]}".strip+"'"
                                temp_str_5=temp_str_5+"'"+"#{row[5]}".strip+"'"
                                temp_str_6=temp_str_6+"'"+"#{row[6]}".strip+"'"
                                temp_str_7=temp_str_7+"'"+"#{row[7]}".strip+"'"
                                temp_str_8=temp_str_8+"'"+"#{row[8]}".strip+"'"
                            end
                            
                            i_num=i_num+1
                        end
                    end
                    flash[:import_result_1] = "文件上传成功！新导入#{i_num-1}条记录!"
                end
                temp_str=temp_str+"];"
                temp_str_2=temp_str_2+"]];"
                temp_str_4=temp_str_4+"]]];"
                temp_str_5=temp_str_5+"]]];"
                temp_str_6=temp_str_6+"]]];"
                temp_str_7=temp_str_7+"]]];"
                temp_str_8=temp_str_8+"]]];"
                sta_f.puts(temp_str)
                sta_f.puts(temp_str_2)
                sta_f.puts(temp_str_4)
                sta_f.puts(temp_str_5)
                sta_f.puts(temp_str_6)
                sta_f.puts(temp_str_7)
                sta_f.puts(temp_str_8)
                sta_f.close
            end
            else
            flash[:import_result_1] = "文件上传失败！"
        end
        respond_to do |format|
            format.html {redirect_to :action => "index",:controller=>"hzp_bsbs" }
        end
    end
    def change_data_excel
        if current_user.is_admin?
            
            @hzp_bsbs= HzpBsb.all
            else
            @hzp_bsbs = HzpBsb.all(:conditions=>["hzp_s_3=?",session[:user_province]],:order=>'hzp_d_90 DESC')
            
        end
        
        count_row=1
        @hzp_bsbs.each do |bsb|
            
            if bsb.hzp_s_52!=nil&&bsb.hzp_s_52!=''
                hzp_data=Hzpdatum.new
                hzp_data.hzpdata_0=bsb.hzp_s_48
                hzp_data.hzpdata_1=bsb.hzp_s_50
                hzp_data.hzpdata_2=bsb.hzp_s_51
                hzp_data.hzpdata_3=bsb.hzp_s_52
                hzp_data.hzpdata_4=bsb.hzp_s_53
                hzp_data.hzpdata_5=bsb.hzp_s_54
                hzp_data.hzpdata_6=bsb.hzp_s_55
                hzp_data.hzpdata_7=bsb.hzp_s_56
                hzp_data.hzpdata_8=bsb.hzp_s_57
                hzp_data.hzpdata_9=bsb.hzp_s_58
                hzp_data.hzp_bsb_id=bsb.id
                hzp_data.save
                count_row += 1
            end
            i=10
            while i<(bsb.hzp_n_jcxcount+9)
                hzp_data=Hzpdatum.new
                hzp_data.hzpdata_0=bsb["hzp_s_1#{i}_0"]
                hzp_data.hzpdata_1=bsb["hzp_s_1#{i}_1"]
                hzp_data.hzpdata_2=bsb["hzp_s_1#{i}_2"]
                hzp_data.hzpdata_3=bsb["hzp_s_1#{i}_3"]
                hzp_data.hzpdata_4=bsb["hzp_s_1#{i}_4"]
                hzp_data.hzpdata_5=bsb["hzp_s_1#{i}_5"]
                hzp_data.hzpdata_6=bsb["hzp_s_1#{i}_6"]
                hzp_data.hzpdata_7=bsb["hzp_s_1#{i}_7"]
                hzp_data.hzpdata_8=bsb["hzp_s_1#{i}_8"]
                hzp_data.hzpdata_9=bsb["hzp_s_1#{i}_9"]
                hzp_data.hzp_bsb_id=bsb.id
                hzp_data.save
                i=i+1
                count_row += 1
            end
            
        end
    end
    
end

