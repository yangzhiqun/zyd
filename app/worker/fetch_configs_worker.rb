class FetchConfigsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  require 'food/token_manager'
  include Food

	def perform
    Unirest.timeout(300)
    @token_manager = TokenManager.new
		response = Utils.post(Url::FetchConfig, {access_token: @token_manager.get_token, data: @form_data.to_json})

		ActiveRecord::Base.transaction do
			if response['status'] == 'OK'
				response['configs']['baosongs'].each do |baosong|
					baosong_a = BaosongA.find_by_name(baosong['a_name'])
					if baosong_a.nil?
						baosong_a = BaosongA.new(name: baosong['a_name'])
						baosong_a.save
					end

					baosong_b = BaosongB.find_by_identifier(baosong['identifier'])
					if baosong_b.nil?
						baosong_b = BaosongB.new(name: baosong['b_name'], identifier: baosong['identifier'])
						baosong_b.baosong_a_id = baosong_a.id
						baosong_b.via_api = true
						baosong_b.save
					end

					baosong_b.via_api = true
					baosong_b.name = baosong['b_name']
					baosong_b.baosong_a_id = baosong_a.id
					baosong_b.save
				end

				response['configs']['a_categories'].each do |a_category|
					a = ACategory.where(identifier: a_category['identifier'], name: a_category['name']).last
					if a.nil?
						a = ACategory.new(identifier: a_category['identifier'], name: a_category['name'], enable: true)
						a.save
					end

					# walk b_categories
					a_category['b_categories'].each do |b_category|
						b = BCategory.where(a_category_id: a.id, name: b_category['name']).last
						if b.nil?
							b = BCategory.new(a_category_id: a.id, name: b_category['name'])
							b.identifier = a.identifier
							b.save
						end

						# walk c_categories
						b_category['c_categories'].each do |c_category|
							c = CCategory.where(b_category_id: b.id, name: c_category['name']).last
							if c.nil?
								c = CCategory.new(b_category_id: b.id, name: c_category['name'])
								c.a_category_id = a.id
								c.identifier = a.identifier
								c.save
							end

							# walk d_categories
							c_category['d_categories'].each do |d_category|
								d = DCategory.where(c_category_id: c.id, name: d_category['name']).last
								if d.nil?
									d = DCategory.new(c_category_id: c.id, name: d_category['name'])
									d.a_category_id = a.id
									d.b_category_id = b.id
									d.c_category_id = c.id
									d.identifier = a.identifier
									d.save
								end

								# Walk check items
								d_category['check_items'].each do |item|
									i = CheckItem.where(d_category_id: d.id, identifier: a.identifier, name: item['name']).last
									if i.nil?
										i = CheckItem.new(d_category_id: d.id, identifier: a.identifier, name: item['name'])
										i.assign_attributes(item)
										i.id = nil
										i.a_category_id = a.id
										i.b_category_id = b.id
										i.c_category_id = c.id
										i.d_category_id = d.id
										i.save
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
