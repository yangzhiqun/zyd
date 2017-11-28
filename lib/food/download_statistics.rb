# encoding: UTF-8

module DownloadStatistics
  class << self 

    def start(type,data)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => "totles"
      sheet.row(0).concat eval(type)
      savetempfile="public/#{Time.now.strftime("%Y")}-统计结果.xls"
      book.write(savetempfile)
      return savetempfile
    end
  end
end
