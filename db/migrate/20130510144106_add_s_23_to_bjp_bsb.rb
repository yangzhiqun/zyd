class AddS23ToBjpBsb < ActiveRecord::Migration
  def change
    
      add_column :bjp_bsbs, :bjp_s_89, :string
      add_column :bjp_bsbs, :bjp_s_90, :string
      add_column :bjp_bsbs, :bjp_s_91, :string
      add_column :bjp_bsbs, :bjp_s_92, :string
      add_column :bjp_bsbs, :bjp_s_93, :string
      add_column :bjp_bsbs, :bjp_s_94, :string
      add_column :bjp_bsbs, :bjp_d_95, :date
      add_column :bjp_bsbs, :bjp_s_96, :string
      add_column :bjp_bsbs, :bjp_s_97, :string
  end
end
