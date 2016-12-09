class StandardCheckItem < ActiveRecord::Base
  belongs_to :standard_b_categorie
  belongs_to :standard_c_categorie
  belongs_to :standard_d_categorie
  belongs_to :standard_check_item
end
