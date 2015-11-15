class DebanCategory < ActiveRecord::Base
	#establish_connection 'deban'
	#self.table_name = 'am_type'

	def self.a_categories
		DebanCategory.where(type_layer: CategoryLayer::A)
	end

	# 子类别
	def sub_categories
		DebanCategory.where("type_code like ?", "#{self.type_code}___")
	end

	module CategoryLayer
		A = 1
		B = 2
		C = 3
		D = 4
	end
end
