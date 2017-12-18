# encoding: UTF-8

module DownloadStatistics
  class << self 

    def start(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat eval(type)
      count_row=1
      data.each do |info|
        num = 0
        info.each do |key,value|
          unless key == :children
            sheet[count_row, num] = value
            num += 1
          else
            count_row += 1
            value.each do |su|  
              num_1 = 0
              su.each do |key_1,value_1|
                sheet[count_row, num_1] = value_1
                num_1 += 1
              end
              num_1 = 0
              count_row += 1
            end
          end
        end 
        num = 0
        count_row += 1
      end
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end
  end
end
