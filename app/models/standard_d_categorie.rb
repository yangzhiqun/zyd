class StandardDCategorie < ActiveRecord::Base
	belongs_to :standard_a_categorie
	belongs_to :standard_b_categorie
	belongs_to :standard_c_categorie
  has_many :standard_check_items, dependent: :delete_all
end
