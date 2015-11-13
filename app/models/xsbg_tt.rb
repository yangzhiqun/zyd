class XsbgTt < ActiveRecord::Base
  attr_accessible :CJBH, :GJMC, :sp_bsb_id, :spdata_ids
	attr_accessor :spdata_ids

	validates_uniqueness_of :sp_bsb_id, :message => "已存在该条报告信息"

	after_create :save_data

	private
	def save_data
		Spdatum.where("id IN (?)", self.spdata_ids.split(',').map{|id| id.to_i}).each do |data|
			xsbg_data = XsbgTtDatum.new(spdata_id: data.id, sp_bsb_id: data.sp_bsb_id, xsbg_tt_id: self.id, CJBH: self.CJBH)
			data.attributes.keys.each do |key|
				if !['updated_at', 'created_at', 'id'].include?(key)
					xsbg_data.send("#{key}=", data[key])
				end
			end
			xsbg_data.save
		end
	end
end
