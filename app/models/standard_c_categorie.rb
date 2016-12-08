class StandardCCategorie < ActiveRecord::Base
	belongs_to :standard_a_categorie
	belongs_to :standard_b_categorie
  has_many :standard_d_categories, dependent: :delete_all
  has_many :standard_check_items, dependent: :delete_all
end
