class AddRefuseReasonToPadSpBsbs < ActiveRecord::Migration
  def change
		add_column :pad_sp_bsbs, :refuse_reason, :text
		add_column :pad_sp_bsbs, :accept_file_path, :string
  end
end
