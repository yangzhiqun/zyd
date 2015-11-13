#encoding=UTF-8
class BjpBsbsController < ApplicationController
  before_filter :init
    
    def init
        if session[:user_name]=='admin'
            @admin_user=1
        else
            @admin_user=0
        end
        @avala=[2,12,15,16,25,27,32,40,49,56,61,62,65,70]
        @options=[]
        @avala.each do |i|
                @options[i]=Flexcontent.find_all_by_flex_field("bjp_bsb_bjp_s_#{i}",:order=>"flex_sortid ASC")
                @options[i]=@options[i].map{|option|[option[:flex_name],option[:flex_id]]}
        end
        
        
        if session[:user_authority_1]==0&&session[:user_authority_2]==0
            redirect_to :controller => 'main', :action => 'authority'
        end
        
    end

    
    # GET /bjp_bsbs
    # GET /bjp_bsbs.json
  

    def index
            
        #Product1.new
        #Product1.import("name.xls")
            
        #@product1=Product1.all
                    
        
            @ending_time=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
            @begin_time=(Time.now-2592000).year.to_s+'-'+(Time.now-2592000).mon.to_s+'-'+(Time.now-2592000).day.to_s
            if session[:user_name]=='admin'
         
                @bjp_bsbs= BjpBsb.select("bjp_d_95,bjp_d_34,bjp_s_3,bjp_s_14,bjp_s_13,bjp_s_31,bjp_s_39,id,bjp_i_state").paginate(:page=>params[:page],:order=>'bjp_d_95 DESC,bjp_s_14',:per_page=> 10)
                
            else
                #@bjp_bsbs = BjpBsb.paginate(:page=>params[:page],:conditions=>["bjp_s_3=?",session[:user_province]],:order=>'bjp_d_95 DESC,bjp_s_14',:per_page=> 10)
                @bjp_bsbs = BjpBsb.select("bjp_d_95,bjp_d_34,bjp_s_3,bjp_s_14,bjp_s_13,bjp_s_31,bjp_s_39,id,bjp_i_state").paginate(:page=>params[:page],:conditions=>["bjp_s_3=?",session[:user_province]],:order=>'bjp_d_95 DESC,bjp_s_14',:per_page=> 10)
                #@bjp_bsbs.each do |bjp|
                #logger.debug(bjp.bjp_d_95)
                #end
            end
            if params[:page]
                session[:bjp_page]=params[:page]
            else
                session[:bjp_page]=1
            end
            respond_to do |format|
                format.html # index.html.erb
                format.json { render json: @bjp_bsbs }
            end
        
  end
    


  # GET /bjp_bsbs/1
  # GET /bjp_bsbs/1.json
  def show
    
    @bjp_bsb = BjpBsb.find(params[:id])
    @bjp_jcxcount=@bjp_bsb.bjp_n_jcxcount
    @bjp_data=Bjpdatum.find_all_by_bjp_bsb_id(params[:id])
  end

  # GET /bjp_bsbs/new
  # GET /bjp_bsbs/new.json
  def new
      if session[:user_authority_1]==0
          redirect_to :controller => 'main', :action => 'authority'
          return
      end

      @bjp_bsb = BjpBsb.new
      @bjp_bsb.bjp_s_94=session[:user_tname]
      @bjp_bsb.bjp_s_31=session[:user_company]
      @bjp_bsb.tname=session[:user_name]
      @bjp_bsb.bjp_s_33=session[:user_name]
      @bjp_bsb.bjp_s_36=session[:user_tname]
      @bjp_bsb.bjp_s_37=session[:user_tel]
      @bjp_bsb.bjp_s_38=session[:user_mail]
      @bjp_bsb.bjp_i_state=0
      @bjp_bsb.bjp_d_95=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
      
      @bjp_jcxcount=1
      respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @bjp_bsb }
      end
  end

  # GET /bjp_bsbs/1/edit
  def edit
    @bjp_bsb = BjpBsb.find(params[:id])
    @bjp_jcxcount=@bjp_bsb.bjp_n_jcxcount
    @bjp_data=Bjpdatum.find_all_by_bjp_bsb_id(params[:id])
  end

  # POST /bjp_bsbs
  # POST /bjp_bsbs.json
  def create
      logger.debug("jump to create")
      @bjp_bsb = BjpBsb.new(params[:bjp_bsb])
      @bjp_bsb.tname=session[:user_name]
      result_record=BjpBsb.find(:first, :conditions => [ "bjp_s_14=?",params[:bjp_bsb][:bjp_s_14]])
      respond_to do |format|
          ActiveRecord::Base.transaction do
              if result_record!=nil
                  flash[:import_result] = "保存不成功，数据库中已有该样品编号!"
                  format.html { render action: "new" }
              else
                  if @bjp_bsb.save
                      if params[:bjpdata]
                          params[:bjpdata].each do |data|
                              data.delete(:id)
                              data[:bjp_bsb_id] =@bjp_bsb.id
                              Bjpdatum.create!(data)
                          end
                      end
                      format.html { redirect_to(:action => "index",:controller=>"bjp_bsbs") }
                      format.json { render json: @bjp_bsb, status: :created, location: @bjp_bsb }
                  else
                      format.html { render action: "new"}
                      format.json { render json: @bjp_bsb.errors, status: :unprocessable_entity }
                  end
              end
          end
      end
  end

  # PUT /bjp_bsbs/1
  # PUT /bjp_bsbs/1.json
  def update
    logger.debug("jump to update")        
    @bjp_bsb = BjpBsb.find(params[:id])
    result_record=BjpBsb.find(:first, :conditions => [ "bjp_s_14=?",params[:bjp_bsb][:bjp_s_14]])
    if (@bjp_bsb.bjp_s_14==params[:bjp_bsb][:bjp_s_14])||(result_record==nil)
        respond_to do |format|
            if @bjp_bsb.update_attributes(params[:bjp_bsb])
                @bjp_bsb.bjpdata.destroy_all
                if params[:bjpdata]
                    params[:bjpdata].each do |data|
                        data.delete(:id)
                        data[:bjp_bsb_id] = params[:id]
                        Bjpdatum.create!(data)
                    end
                end
                format.html { redirect_to("/bjp_bsbs?page=#{session[:bjp_page]}")}
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @bjp_bsb.errors, status: :unprocessable_entity }
            end
        end
    else
        respond_to do |format|
            flash[:import_result] ="修改不成功，数据库中已有该样品编号!"
            @temp_bjp_bsb = BjpBsb.find(params[:id])
            params[:bjp_bsb][:bjp_s_14]=@temp_bjp_bsb.bjp_s_14#改回原编号，更新内容不变
            @bjp_bsb.assign_attributes params[:bjp_bsb]
            @bjp_data=params[:bjpdata]
            format.html { render action: "edit"}
        end
    end

  end

  # DELETE /bjp_bsbs/1
  # DELETE /bjp_bsbs/1.json
  def destroy
    @bjp_bsb = BjpBsb.find(params[:id])
    @bjp_bsb.destroy

    respond_to do |format|
      format.html { redirect_to "/bjp_bsbs?page=#{session[:bjp_page]}" }
      format.json { head :no_content }
    end
  end
    
  # POST /bjp_bsbs/bjpsearch
  # POST /bjp_bsbs/search.json
    def bjpsearch
        str="bjp_d_95>=? and bjp_d_95<=?"
        if params[:begin_time]
            @begin_time=params[:begin_time]
        end
        if params[:ending_time]
            @ending_time=params[:ending_time]
        end
        if params[:s1]!=''#采样单位
            str=str+" and bjp_s_31 like ?"
            @s1=params[:s1]
            @s1='%'+@s1+'%'
            else
            str=str+" and (bjp_s_31 is null or bjp_s_31 like ?)"
            @s1='%%'
        end
        if params[:s2]!=''#检验机构
            str=str+" and bjp_s_39 like ?"
            @s2=params[:s2]
            @s2='%'+@s2+'%'
            else
            str=str+" and (bjp_s_39 is null or bjp_s_39 like ?)"
            @s2='%%'
        end
        if params[:s3]!=''#填报人
            str=str+" and bjp_s_94 like ?"
            @s3=params[:s3]
            @s3='%'+@s3+'%'
            else
            str=str+" and (bjp_s_94 is null or bjp_s_94 like ?)"
            @s3='%%'
        end
        if params[:s4]!=''#样品名称
            str=str+" and bjp_s_13 like ?"
            @s4=params[:s4]
            @s4='%'+@s4+'%'
            else
            str=str+" and (bjp_s_13 is null or bjp_s_13 like ?)"
            @s4='%%'
        end
        if params[:s7]!=''#采样编号
            str=str+" and bjp_s_14 like ?"
            @s7=params[:s7]
            @s7='%'+@s7+'%'
            else
            str=str+" and (bjp_s_14 is null or bjp_s_14 like ?)"
            @s7='%%'
        end
        str=str+" and bjp_i_state>=? and bjp_i_state<=?"
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
        
        if session[:user_name]=='admin'
            @bjp_bsbs = BjpBsb.select("bjp_d_95,bjp_d_34,bjp_s_3,bjp_s_14,bjp_s_13,bjp_s_31,bjp_s_39,id,bjp_i_state").paginate(:page=>params[:page],:order=>'bjp_d_95 DESC',:per_page=> 10,:conditions=>[str,@begin_time,@ending_time,@s1,@s2,@s3,@s4,@s7,@s8,@s9])
            else
            @bjp_bsbs = BjpBsb.select("bjp_d_95,bjp_d_34,bjp_s_3,bjp_s_14,bjp_s_13,bjp_s_31,bjp_s_39,id,bjp_i_state").paginate(:page=>params[:page],:order=>'bjp_d_95 DESC',:per_page=> 10,:conditions=>["bjp_s_3=? and "+str,session[:user_province],@begin_time,@ending_time,@s1,@s2,@s3,@s4,@s7,@s8,@s9])
        end
            
        
                    
        
        respond_to do |format|
            format.html { render action: "index"}
            format.json { render json: @bjp_bsbs }
        end
    end
    # get /bjp_bsbs/submit
    def submit
        @bjp_bsb = BjpBsb.find(params[:id])
        @bjp_bsb.update_attribute(:bjp_i_state,1)
        
        respond_to do |format|
            format.html {redirect_to "/bjp_bsbs?page=#{session[:bjp_page]}" }
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
                    elsif (session[:user_province]==row[3])||(session[:user_name]=='admin'&&row[3]!=nil)
                        
                        result_record=BjpBsb.find(:first, :conditions => [ "bjp_s_3 = ? and bjp_s_14=?",row[3],row[13]])
                        if result_record==nil&&row[13]!=nil
                            @bsb = BjpBsb.new
                        
                            @bsb.bjp_s_70=row[0]
                            @bsb.bjp_s_1=row[1]
                            @bsb.bjp_s_2=row[2]
                            @bsb.bjp_s_3=row[3]
                            @bsb.bjp_s_4=row[4]
                            @bsb.bjp_s_5=row[5]
                            @bsb.bjp_s_6=row[6]
                            @bsb.bjp_s_9=row[7]
                            @bsb.bjp_s_7=row[8]
                            @bsb.bjp_s_8=row[9]
                            @bsb.bjp_s_10=row[10]
                            @bsb.bjp_s_11=row[11]
                            @bsb.bjp_s_13=row[12]
                            @bsb.bjp_s_14=row[13]
                            @bsb.bjp_s_15=row[14]
                            @bsb.bjp_s_16=row[15]
                            @bsb.bjp_s_17=row[16]
                            @bsb.bjp_s_12=row[17]
                            @bsb.bjp_s_18=row[18]
                            @bsb.bjp_s_19=row[19]
                            @bsb.bjp_s_20=row[20]
                            @bsb.bjp_d_21=row[21]
                            @bsb.bjp_s_22=row[22]
                            @bsb.bjp_s_61=row[23]
                            @bsb.bjp_s_62=row[24]
                            @bsb.bjp_s_23=row[25]
                            @bsb.bjp_n_24=row[26]
                            @bsb.bjp_s_25=row[27]
                            @bsb.bjp_n_26=row[28]
                            @bsb.bjp_s_27=row[29]
                            @bsb.bjp_s_28=row[30]
                            @bsb.bjp_s_29=row[31]
                            @bsb.bjp_s_63=row[32]
                            @bsb.bjp_s_64=row[33]
                            @bsb.bjp_s_30=row[34]
                            @bsb.bjp_s_31=row[35]
                            @bsb.bjp_s_32=row[36]
                            @bsb.bjp_s_33=row[37]
                            @bsb.bjp_d_34=row[38]
                            @bsb.bjp_s_35=row[39]
                            @bsb.bjp_s_36=row[40]
                            @bsb.bjp_s_37=row[41]
                            @bsb.bjp_s_38=row[42]
                            @bsb.bjp_s_65=row[43]
                            @bsb.tname=session[:user_name]
                            @bsb.bjp_s_94="#{session[:user_name]}批量导入"
                            @bsb.bjp_i_state=10
                            @bsb.bjp_n_jcxcount=1
                            @bsb.bjp_d_95=(Time.now).year.to_s+'-'+(Time.now).mon.to_s+'-'+(Time.now).day.to_s
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
           format.html {redirect_to :action => "index",:controller=>"bjp_bsbs" }
        end
    end
    def export_excel
        if session[:user_name]=='admin'
            
            @bjp_bsbs= BjpBsb.all(:limit=>5,:order=>'bjp_d_95 DESC')
            
        else
            @bjp_bsbs = BjpBsb.all(:limit=>5,:conditions=>["bjp_s_3=?",session[:user_province]],:order=>'bjp_d_95 DESC')
            
        end
        book = Spreadsheet::Workbook.new
        sheet =book.create_worksheet :name=>"totles"
        
        sheet.row(0).concat %w{报送分类* 被采样单位名称* 单位类型* 省(市、自治区)* 地区(市、州、盟)* 县(市、区)* 单位地址* 邮编 被采样单位法人（负责人） 电话 被采样单位负责（联系）人* 电话* 样品名称* 抽样编号* 功能分类* 管理分类* 进口国/产地* 剂型* 规格* 包装规格* 生产批号* 生产日期* 保质期* 标签说明规范情况* 批准文号-1* 批准文号-2* 采样数量* 数量单位* 货物数量 货物数量单位 标识生产企业名称* 标识生产企业地址* 委托生产企业名称 委托生产企业地址 备注 采样单位名称* 单位级别* 抽样人员* 抽样时间* 电话* 采样单位负责（联系）人* 电话* 电子邮箱* 地域类型*}
        count_row=1
        @bjp_bsbs.each do |bsb|
            sheet[count_row,0]=bsb.bjp_s_70
            sheet[count_row,1]=bsb.bjp_s_1
            sheet[count_row,2]=bsb.bjp_s_2
            sheet[count_row,3]=bsb.bjp_s_3
            sheet[count_row,4]=bsb.bjp_s_4
            sheet[count_row,5]=bsb.bjp_s_5
            sheet[count_row,6]=bsb.bjp_s_6
            sheet[count_row,7]=bsb.bjp_s_9
            sheet[count_row,8]=bsb.bjp_s_7
            sheet[count_row,9]=bsb.bjp_s_8
            sheet[count_row,10]=bsb.bjp_s_10
            sheet[count_row,11]=bsb.bjp_s_11
            sheet[count_row,12]=bsb.bjp_s_13
            sheet[count_row,13]=bsb.bjp_s_14
            sheet[count_row,14]=bsb.bjp_s_15
            sheet[count_row,15]=bsb.bjp_s_16
            sheet[count_row,16]=bsb.bjp_s_17
            sheet[count_row,17]=bsb.bjp_s_12
            sheet[count_row,18]=bsb.bjp_s_18
            sheet[count_row,19]=bsb.bjp_s_19
            sheet[count_row,20]=bsb.bjp_s_20
            sheet[count_row,21]=bsb.bjp_d_21
            sheet[count_row,22]=bsb.bjp_s_22
            sheet[count_row,23]=bsb.bjp_s_61
            sheet[count_row,24]=bsb.bjp_s_62
            sheet[count_row,25]=bsb.bjp_s_23
            sheet[count_row,26]=bsb.bjp_n_24
            sheet[count_row,27]=bsb.bjp_s_25
            sheet[count_row,28]=bsb.bjp_n_26
            sheet[count_row,29]=bsb.bjp_s_27
            sheet[count_row,30]=bsb.bjp_s_28
            sheet[count_row,31]=bsb.bjp_s_29
            sheet[count_row,32]=bsb.bjp_s_63
            sheet[count_row,33]=bsb.bjp_s_64
            sheet[count_row,34]=bsb.bjp_s_30
            sheet[count_row,35]=bsb.bjp_s_31
            sheet[count_row,36]=bsb.bjp_s_32
            sheet[count_row,37]=bsb.bjp_s_33
            sheet[count_row,38]=bsb.bjp_d_34
            sheet[count_row,39]=bsb.bjp_s_35
            sheet[count_row,40]=bsb.bjp_s_36
            sheet[count_row,41]=bsb.bjp_s_37
            sheet[count_row,42]=bsb.bjp_s_38
            sheet[count_row,43]=bsb.bjp_s_65
            count_row += 1
        end
        savetempfile="public/#{session[:user_name]}#{(Time.now).to_s}bjp_template.xls"
        book.write(savetempfile)
        send_file(savetempfile,:disposition => "attachment")
    end
    def export_info_excel
        savetempfile="public/#{session[:user_province]}#{session[:user_name]}#{(Time.now).year.to_s}年#{(Time.now).month.to_s}月#{(Time.now).day.to_s}日保健品基本信息.xls"
        flag = FileTest::exist?(savetempfile)
        if !flag
            if session[:user_name]=='admin'
                @bjp_bsbs= BjpBsb.all(:order=>'bjp_d_95 DESC')
            else
                @bjp_bsbs = BjpBsb.all(:conditions=>["bjp_s_3=?",session[:user_province]],:order=>'bjp_d_95 DESC')
            
            end
            book = Spreadsheet::Workbook.new
            sheet =book.create_worksheet :name=>"totles"
        
            sheet.row(0).concat %w{报送分类* 被采样单位名称* 单位类型* 省(市、自治区)* 地区(市、州、盟)* 县(市、区)* 单位地址* 邮编 被采样单位法人（负责人） 电话 被采样单位负责（联系）人* 电话* 样品名称* 抽样编号* 功能分类* 管理分类* 进口国/产地* 剂型* 规格* 包装规格* 生产批号* 生产日期* 保质期* 标签说明规范情况* 批准文号-1* 批准文号-2* 采样数量* 数量单位* 货物数量 货物数量单位 标识生产企业名称* 标识生产企业地址* 委托生产企业名称 委托生产企业地址 备注 采样单位名称* 单位级别* 抽样人员* 抽样时间* 电话* 采样单位负责（联系）人* 电话* 电子邮箱* 地域类型*}
            count_row=1
            @bjp_bsbs.each do |bsb|
                sheet[count_row,0]=bsb.bjp_s_70
                sheet[count_row,1]=bsb.bjp_s_1
                sheet[count_row,2]=bsb.bjp_s_2
                sheet[count_row,3]=bsb.bjp_s_3
                sheet[count_row,4]=bsb.bjp_s_4
                sheet[count_row,5]=bsb.bjp_s_5
                sheet[count_row,6]=bsb.bjp_s_6
                sheet[count_row,7]=bsb.bjp_s_9
                sheet[count_row,8]=bsb.bjp_s_7
                sheet[count_row,9]=bsb.bjp_s_8
                sheet[count_row,10]=bsb.bjp_s_10
                sheet[count_row,11]=bsb.bjp_s_11
                sheet[count_row,12]=bsb.bjp_s_13
                sheet[count_row,13]=bsb.bjp_s_14
                sheet[count_row,14]=bsb.bjp_s_15
                sheet[count_row,15]=bsb.bjp_s_16
                sheet[count_row,16]=bsb.bjp_s_17
                sheet[count_row,17]=bsb.bjp_s_12
                sheet[count_row,18]=bsb.bjp_s_18
                sheet[count_row,19]=bsb.bjp_s_19
                sheet[count_row,20]=bsb.bjp_s_20
                sheet[count_row,21]=bsb.bjp_d_21
                sheet[count_row,22]=bsb.bjp_s_22
                sheet[count_row,23]=bsb.bjp_s_61
                sheet[count_row,24]=bsb.bjp_s_62
                sheet[count_row,25]=bsb.bjp_s_23
                sheet[count_row,26]=bsb.bjp_n_24
                sheet[count_row,27]=bsb.bjp_s_25
                sheet[count_row,28]=bsb.bjp_n_26
                sheet[count_row,29]=bsb.bjp_s_27
                sheet[count_row,30]=bsb.bjp_s_28
                sheet[count_row,31]=bsb.bjp_s_29
                sheet[count_row,32]=bsb.bjp_s_63
                sheet[count_row,33]=bsb.bjp_s_64
                sheet[count_row,34]=bsb.bjp_s_30
                sheet[count_row,35]=bsb.bjp_s_31
                sheet[count_row,36]=bsb.bjp_s_32
                sheet[count_row,37]=bsb.bjp_s_33
                sheet[count_row,38]=bsb.bjp_d_34
                sheet[count_row,39]=bsb.bjp_s_35
                sheet[count_row,40]=bsb.bjp_s_36
                sheet[count_row,41]=bsb.bjp_s_37
                sheet[count_row,42]=bsb.bjp_s_38
                sheet[count_row,43]=bsb.bjp_s_65
                count_row += 1
            end
            book.write(savetempfile)
            send_file(savetempfile,:disposition => "attachment")
        else
            send_file(savetempfile,:disposition => "attachment")
        end
    end
    ###导入保健品检测项标准
    def import_bjp_standards
        uploaded_io = params[:excel]
        accepted_formats = [".xls", ".xlsx"]
        if !uploaded_io.nil? and accepted_formats.include? File.extname(uploaded_io.original_filename) then
            File.open(Rails.root.join('excel', session[:user_name]+(Time.now).to_s+uploaded_io.original_filename), 'wb') do |file|
                file.write(uploaded_io.read)
                sta_f=File.new(File.join("app/assets/javascripts/bjpdata.js"), "w+")
                #f.puts("I am Jack")
                #f.puts("Hello World")
                book = Spreadsheet.open(Rails.root.join('excel',session[:user_name]+(Time.now).to_s+uploaded_io.original_filename))
                sheet1 = book.worksheet 0
                i_num=0
                temp_str='var BJPDL=['
                temp_str_1='var BJPXL=['
                temp_str_2='var BJPJCX=['
                temp_str_3='var BJPJCDW=['
                temp_str_5='var BJPJCYJ=['
                temp_str_4='var BJPPDYJ=['
                
                flag_1=0;
                
                ActiveRecord::Base.transaction do
                    sheet1.each_with_index do |row,index|
                        if i_num<=0
                            i_num=i_num+1
                        elsif session[:user_name]=='admin'
                            if row[0]
                                if flag_1==1
                                    temp_str=temp_str+","
                                    temp_str_1=temp_str_1+"],"
                                    temp_str_2=temp_str_2+"]],"
                                    temp_str_3=temp_str_3+"]],"
                                    temp_str_5=temp_str_5+"]],"
                                    temp_str_4=temp_str_4+"]]],"
                                end
                                flag_1=1
                                temp_str=temp_str+"'"+"#{row[0]}".strip+"'"
                                temp_str_1=temp_str_1+"['"+"#{row[1]}".strip+"'"
                                temp_str_2=temp_str_2+"[['"+"#{row[2]}".strip+"'"
                                temp_str_3=temp_str_3+"[['"+"#{row[3]}".strip+"'"
                                temp_str_5=temp_str_5+"[['"+"#{row[5]}".strip+"'"
                                temp_str_4=temp_str_4+"[[['"+"#{row[4]}".strip+"'"
                               
                            elsif row[1]
                                temp_str_2=temp_str_2+"],["
                                temp_str_3=temp_str_3+"],["
                                temp_str_5=temp_str_5+"],["
                                temp_str_4=temp_str_4+"]],[["
                                
                                temp_str_1=temp_str_1+","
                                temp_str_1=temp_str_1+"'"+"#{row[1]}".strip+"'"
                                temp_str_2=temp_str_2+"'"+"#{row[2]}".strip+"'"
                                temp_str_3=temp_str_3+"'"+"#{row[3]}".strip+"'"
                                temp_str_5=temp_str_5+"'"+"#{row[5]}".strip+"'"
                                temp_str_4=temp_str_4+"'"+"#{row[4]}".strip+"'"
                                
                            elsif row[2]
                                temp_str_4=temp_str_4+"],["

                                temp_str_2=temp_str_2+","
                                temp_str_3=temp_str_3+","
                                temp_str_5=temp_str_5+","
            
                                
                                
                                temp_str_2=temp_str_2+"'"+"#{row[2]}".strip+"'"
                                temp_str_3=temp_str_3+"'"+"#{row[3]}".strip+"'"
                                temp_str_5=temp_str_5+"'"+"#{row[5]}".strip+"'"
                                temp_str_4=temp_str_4+"'"+"#{row[4]}".strip+"'"
                            elsif row[4]
                                
                                temp_str_4=temp_str_4+","
                                
                                
                                
                                temp_str_4=temp_str_4+"'"+"#{row[4]}".strip+"'"
                                
                            end
                            
                            i_num=i_num+1
                        end
                    end
                    flash[:import_result_1] = "文件上传成功！新导入#{i_num-1}条记录!"
                end
                temp_str=temp_str+"];"
                temp_str_1=temp_str_1+"]];"
                temp_str_2=temp_str_2+"]]];"
                temp_str_3=temp_str_3+"]]];"
                temp_str_5=temp_str_5+"]]];"
                temp_str_4=temp_str_4+"]]]];"
                
                sta_f.puts(temp_str)
                sta_f.puts(temp_str_1)
                sta_f.puts(temp_str_2)
                sta_f.puts(temp_str_3)
                sta_f.puts(temp_str_5)
                sta_f.puts(temp_str_4)
                
                sta_f.close
            end
            else
            flash[:import_result_1] = "文件上传失败！"
        end
        respond_to do |format|
            format.html {redirect_to :action => "index",:controller=>"bjp_bsbs" }
        end
    end
end