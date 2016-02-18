namespace :ca do
  desc "导入ca签章图片"
  task import_ca_picture: :environment do
		xls_path = Rails.root.join('jg_ca_stamps', 'rules.xls')
		pic_path_pattern = Rails.root.join('jg_ca_stamps', 'stamps', '%s.gif').to_s

		book = Spreadsheet.open(xls_path)
		book.worksheet(0).each do |row|
			jg = JgBsb.find_by_history_name(row[0])
			if jg.present?
				puts "#{jg.jg_name} => #{File.exists?(pic_path_pattern % [row[1]])}"
				base_path = "#{Rails.application.config.attachment_path}/jg_bsb_stamps"

				target_path = "#{base_path}/#{Time.now.strftime("%Y/%m/%d")}"

				if File.exists?(pic_path_pattern % [row[1].strip])
					FileUtils.mkdir_p(target_path) unless Dir.exists?(target_path)
					FileUtils.cp((pic_path_pattern % [row[1]]), "#{target_path}/#{row[1].strip}#{File.extname((pic_path_pattern % [row[1]]))}")

					stamp = JgBsbStamp.find_by_stamp_no(row[1].strip)
					if stamp.nil?
						stamp = JgBsbStamp.new(jg_bsb_id: jg.id, stamp_no: row[1].strip, note: 'create from rake task', name: row[2], stamp_type: row[1].strip.split('_')[1])
					end
					stamp.image_path = "jg_bsb_stamps/#{Time.now.strftime("%Y/%m/%d")}/#{row[1].strip}#{File.extname((pic_path_pattern % [row[1]]))}"
					stamp.save
					puts 'OK'
				else
					puts 'ERR: file not exists.'
				end
			else
				puts 'ERR: JG not exists.'
			end
		end
  end

end
