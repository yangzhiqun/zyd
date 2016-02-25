namespace :jg do
  desc "导入机构信息"
  task import_jg_info: :environment do
    xls_path = Rails.root.join('tmp', 'jginfo.xls')
    book = Spreadsheet.open(xls_path)
    book.worksheet(1).each do |row|
      row = row.map { |r| r.to_s.strip }
      if row[2].empty? || row[2] == "\\"
      else
        jg = JgBsb.find_by_history_name(row[2])
        if jg.present?
          if row[1].eql? "0新增"
            puts "标签：#{row[1]}|准备更新：#{row[2]}"
          end
        else
          if row[1].eql? "0新增"
            jg = JgBsb.new(jg_name: row[2])
            jg.jg_address = row[10] unless row[10].eql? "\\"
            jg.jg_province = row[7] unless row[7].eql? "\\"
            if jg.save
              puts "标签：#{row[1]}|新建成功jg_bsbs：#{row[2]}"
              jgname = JgBsbName.new(jg_bsb_id: jg.id, name: row[2])
              if jgname.save
                puts "标签：#{row[1]}|新建成功jg_bsb_names：#{row[2]}"
              else
                puts "标签：#{row[1]}|新建失败jg_bsb_names：#{row[2]}"
              end
            else
              puts "标签：#{row[1]}|新建失败jg_bsbs：#{row[2]}"
            end
          else
            puts "标签：#{row[1]}|机构不存在：#{row[2]}"
          end
        end

        if jg.present?
          jg.jg_higher_level = row[6] unless row[6].eql? "\\"
          jg.jg_province = row[7] unless row[7].eql? "\\"
          jg.city = row[8] unless row[8].eql? "\\"
          jg.country = row[9] unless row[9].eql? "\\"
          jg.jg_address = row[10] unless row[10].eql? "\\"
          jg.zipcode = row[11].to_i.to_s unless row[11].eql? "\\"
          jg.jg_leader = row[12] unless row[12].eql? "\\"
          jg.jg_contacts = row[13] unless row[13].eql? "\\"
          #电话有浮点型
          jg.jg_tel = row[14] unless row[14].eql? "\\"
          jg.jg_email = row[15] unless row[15].eql? "\\"
          #传真有浮点型
          jg.fax = row[16] unless row[16].eql? "\\"
          jg.jg_certification = row[17] unless row[17].eql? "\\"
          jg.jg_word_area = row[18] unless row[18].eql? "\\"
          jg.code = row[22] unless row[22].eql? "\\"

          if row[4].eql? "检验机构"
            jg.jg_type = 3
          elsif row[4].eql? "监管部门"
            jg.jg_type = 1
          end

          if row[19].eql? "是"
            jg.jg_enable = 1
          elsif row[19].eql? "否"
            jg.jg_enable = 0
          end

          if row[20].eql? "是"
            jg.jg_sampling = 1
          elsif row[20].eql? "否"
            jg.jg_sampling = 0
          end

          if row[21].eql? "是"
            jg.jg_detection = 1
          elsif row[21].eql? "否"
            jg.jg_detection = 0
          end

          if jg.save
            puts "标记：#{row[1]}|更新成功：#{row[2]}"
          else
            puts "标记：#{row[1]}|更新失败：#{row[2]}  #{jg.errors.as_json}"
          end
        else
          puts "标签：#{row[1]}|机构不存在：#{row[2]}"
        end
      end
    end
  end
end