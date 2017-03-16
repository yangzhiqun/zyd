# encoding: UTF-8

module DownloadData
  class << self 

	  def start(sp_data)
      @sp_bsbs = sp_data
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat %w{ID 被抽样单位名称* 更新时间 抽样地点_2* 省(市、自治区)* 地区(市、州、盟) 县(市、区) 单位地址(被抽样单位)* 生产许可证号 样品名称 抽样数量 抽样编号* 食品大类 食品亚类 食品次亚类 食品细类 生产/加工/购进日期 样品规格* 样品批号* 生产日期* 保质期* 抽样单位名称* 单位级别* 抽样人员* 抽样时间* 检验机构名称* 检验目的* 报告书编号* 收检日期* 报告日期* 所在省份* 样品类型* 包装分类* 标识生产企业名称 标识生产企业地址* 报送分类-2* 单位地点_1* 报送分类-1* 结论* 商标 任务来源* 样品状态 区域类型* 标识生产企业省份 抽样基数/批量* 备样数量* 营业执照号 报告分类 检验项目* 检验结果* 结果判定* 检验依据* 判定依据* 标准方法检出限* 标准检出限单位* 方法检出限* 检出限单位* 标准最小允许限* 标准最小允许限单位* 最小允许限* 最小允许限单位* 标准最大允许限* 标准最大允许限单位* 最大允许限* 最大允许限单位* 说明 结果单位*}
      count_row = 1
      @sp_bsbs.each do |sp_bsb|
        if sp_bsb.spdata.blank?
          sheet = process(sheet,sp_bsb,[],count_row)
          count_row += 1
        else
          sp_bsb.spdata.each do |data| 
            sheet = process(sheet,sp_bsb,data,count_row)
            count_row += 1
          end
        end
      end
      savetempfile="public/#{Time.now.strftime("%Y-%m-%d-%H:%M")}-检测结果.xls"
      book.write(savetempfile)
      return savetempfile
    end

    def process(sheet,sp_bsb,data,count_row)
      sheet[count_row, 0]  = sp_bsb.id 
      sheet[count_row, 1]  = sp_bsb.sp_s_1 #被抽样单位名称*
      sheet[count_row, 2]  = ((sp_bsb.updated_at).ago(-3600*8)).to_s[0,19] #更新时间
      sheet[count_row, 3]  = sp_bsb.sp_s_2 #抽样地点(第二选项)
      sheet[count_row, 4]  = sp_bsb.sp_s_3 #被抽样单位-省
      sheet[count_row, 5]  = sp_bsb.sp_s_4 #被抽样单位-市
      sheet[count_row, 6]  = sp_bsb.sp_s_5 #被抽样单位-县
      sheet[count_row, 7]  = sp_bsb.sp_s_7 #被抽样单位-详细地址 
      sheet[count_row, 8]  = sp_bsb.sp_s_13 #生产许可证号 
      sheet[count_row, 9]  = sp_bsb.sp_s_14 #样品名称
      sheet[count_row, 10] = sp_bsb.sp_n_15 #抽样数量
      sheet[count_row, 11] = sp_bsb.sp_s_16 #抽样编号 
      sheet[count_row, 12] = sp_bsb.sp_s_17 #食品大类 
      sheet[count_row, 13] = sp_bsb.sp_s_18 #食品亚类
      sheet[count_row, 14] = sp_bsb.sp_s_19 #食品次亚类
      sheet[count_row, 15] = sp_bsb.sp_s_20 #食品细类
      sheet[count_row, 16] = sp_bsb.sp_d_28 #生产/加工/购进日期 
      sheet[count_row, 17] = sp_bsb.sp_s_26 #样品规格
      sheet[count_row, 18] = sp_bsb.sp_s_27 #样品批号 
      sheet[count_row, 19] = sp_bsb.sp_d_28 #生产日期
      sheet[count_row, 20] = sp_bsb.sp_n_29 #保质期
      sheet[count_row, 21] = sp_bsb.sp_s_35 #抽样单位名称
      sheet[count_row, 22] = sp_bsb.sp_s_36 #单位级别
      sheet[count_row, 23] = sp_bsb.sp_s_37 #抽样人员
      sheet[count_row, 24] = sp_bsb.sp_d_38 #抽样时间 
      sheet[count_row, 25] = sp_bsb.sp_s_43 #检验机构名称
      sheet[count_row, 26] = sp_bsb.sp_s_44 #检验目的/任务类别*
      sheet[count_row, 27] = sp_bsb.sp_s_45 #报告书编号
      sheet[count_row, 28] = sp_bsb.sp_d_46 #收检日期
      sheet[count_row, 29] = sp_bsb.sp_d_47 #报告日期
      sheet[count_row, 30] = sp_bsb.sp_s_52 #所在省份
      sheet[count_row, 31] = sp_bsb.sp_s_62 #样品类型
      sheet[count_row, 32] = sp_bsb.sp_s_63 #包装分类
      sheet[count_row, 33] = sp_bsb.sp_s_64 #标识生产企业名称
      sheet[count_row, 34] = sp_bsb.sp_s_65 #标识生产企业地址
      sheet[count_row, 35] = sp_bsb.sp_s_67 #报送分类-2
      sheet[count_row, 36] = sp_bsb.sp_s_68 #单位地点_1
      sheet[count_row, 37] = sp_bsb.sp_s_70 #报送分类-1
      sheet[count_row, 38] = sp_bsb.sp_s_71 #结论 
      sheet[count_row, 39] = sp_bsb.sp_s_74 #商标
      sheet[count_row, 40] = sp_bsb.sp_s_2_1 #任务来源
      sheet[count_row, 41] = SpBsb::SpState[sp_bsb.sp_i_state] #样品状态
      sheet[count_row, 42] = sp_bsb.sp_s_201 #区域类型 
      sheet[count_row, 43] = sp_bsb.sp_s_202 #标识生产企业省份
      sheet[count_row, 44] = sp_bsb.sp_s_206 #抽样基数/批量
      sheet[count_row, 45] = sp_bsb.sp_s_208 #备样数量 
      sheet[count_row, 46] = sp_bsb.sp_s_215 #营业执照号
      sheet[count_row, 47] = sp_bsb.bgfl     #报告分类
      #--------------检验数据-------------
      if data.present?
        sheet[count_row, 48] = data.spdata_0 #检验项目
        sheet[count_row, 49] = data.spdata_1 #检验结果
        sheet[count_row, 50] = data.spdata_2 #结果判定 
        sheet[count_row, 51] = data.spdata_3 #检验依据
        sheet[count_row, 52] = data.spdata_4 #判定依据
        sheet[count_row, 53] = data.spdata_5 #标准方法检出限
        sheet[count_row, 54] = data.spdata_6 #标准检出限单位
        sheet[count_row, 55] = data.spdata_7 #方法检出限
        sheet[count_row, 56] = data.spdata_8 #检出限单位
        sheet[count_row, 57] = data.spdata_9 #标准最小允许限
        sheet[count_row, 58] = data.spdata_10 #标准最小允许限单位
        sheet[count_row, 59] = data.spdata_11 #最小允许限
        sheet[count_row, 60] = data.spdata_12 #最小允许限单位
        sheet[count_row, 61] = data.spdata_13 #标准最大允许限
        sheet[count_row, 62] = data.spdata_14 #标准最大允许限单位
        sheet[count_row, 63] = data.spdata_15 #最大允许限
        sheet[count_row, 64] = data.spdata_16 #最大允许限单位
        sheet[count_row, 65] = data.spdata_17 #说明
        sheet[count_row, 66] = data.spdata_18 #结果单位
      end
      return sheet
    end
  end
end
