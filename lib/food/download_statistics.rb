# encoding: UTF-8

module DownloadStatistics
  class << self 

    def food(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat eval(type)
      count_row=1
      data.each do |info|
        num = 0
        info.each do |key,value|
          sheet[count_row, num] = value.class == Array ? value.length : value
          num += 1
        end 
        num = 0
        count_row+=1
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end

     #"宿松"=>[{:xAxis=>[{:data=>["安徽省水产品及制品质量监督检验中心", "安徽国泰众信检测技术有限公司"]}], :series=>[{:data=>[21, 0]}]}, {:xAxis=>[{:data=>["安徽省水产品及制品质量监督检验中心", "安徽国泰众信检测技术有限公司"]}], :series=>[{:data=>[21, 0]}]}]
    def overtime(data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "抽样机构"
      sheet.row(0).concat ["区域","抽样机构","数量"]
      count_row = 1
      data.each do |city_name,info|
        num = 1
        sheet[count_row, 0] = city_name
        jigou_arr = []
        num_arr = []
        jigou_arr = info[0][:xAxis][0][:data]
        num_arr = info[0][:series][0][:data]
        jigou_arr.each_with_index do |value,index|
          sheet[count_row, num] = value
          sheet[count_row, num+1] = num_arr[index]
          count_row+=1
        end
      end
      sheet1 = book.create_worksheet :name => "检验机构"
      sheet1.row(0).concat ["区域","检验机构","数量"] 
      count_row = 1
      data.each do |city_name,info|
        num = 1
        sheet1[count_row, 0] = city_name
        jigou_arr = []
        num_arr = []
        jigou_arr = info[1][:xAxis][0][:data]
        num_arr = info[1][:series][0][:data]
        jigou_arr.each_with_index do |value,index|
          sheet1[count_row, num] = value
          sheet1[count_row, num+1] = num_arr[index]
          count_row+=1
        end
      end
      savetempfile="public/#{Time.now.strftime("%Y")}.xls"
      book.write(savetempfile)
      return savetempfile
    end

    def nonconformity(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat eval(type)
      count_row=1
      data_arr = []
      data.values.each{ |d| data_arr.concat d }
      data_arr.each do |info|
        num = 0
        info.each do |key,value|
          sheet[count_row, num] = value
          num += 1
        end 
        num = 0
        count_row+=1
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end

    def enterprise(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "抽样机构"
      sheet.row(0).concat eval(type)
      count_row,num = 1,0 
      data.each do |info|
        info.each do |key,value|
          sheet[count_row, num] = value.class == Array ? value.length : value
          num += 1
        end
        count_row += 1
        num = 0
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end

    def retirement(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "抽样机构"
      sheet.row(0).concat eval(type)
      count_row=1
      data["chouyang"].each do |info|
        num = 0
        info.each do |key,value|
          sheet[count_row, num] = value.class == Array ? value.length : value
          num += 1
        end
        count_row+=1
      end
      sheet1 = book.create_worksheet :name => "承检机构"
      sheet1.row(0).concat eval(type)
      count_row=1
      data["chengjian"].each do |info|
        num = 0
        info.each do |key,value|
          sheet1[count_row, num] = value.class == Array ? value.length : value
          num += 1
        end
        count_row+=1
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end

    def composite(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat eval(type)
      count_row=1
      data.each do |info|
        num = 0
        info.each do |key,value|
          unless key == :children
            sheet[count_row, num] = value.class == Array ? value.length : value
            num += 1
          else
            count_row += 1
            value.each do |su|  
              num_1 = 0
              su.each do |key_1,value_1|
                sheet[count_row, num_1] = value_1.class == Array ? value_1.length : value_1
                num_1 += 1
              end
              num_1 = 0
              count_row += 1
            end
          end
        end 
        num = 0
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end
  end
end
