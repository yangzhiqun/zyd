class AddWochachaTaskIdToSpBsbs < ActiveRecord::Migration
  def change
    add_column :sp_bsbs, :wochacha_task_id, :integer unless column_exists? :sp_bsbs, :wochacha_task_id
    add_column :sp_bsbs, :sp_s_sfjk, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_sfjk
    add_column :sp_bsbs, :sp_s_ycg, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_ycg
    add_column :sp_bsbs, :sp_s_sfwtsc, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_sfwtsc
    add_column :sp_bsbs, :sp_s_wtsheng, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_wtsheng
    add_column :sp_bsbs, :sp_s_wtshi, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_wtshi
    add_column :sp_bsbs, :sp_s_wtxian, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_wtxian
    add_column :sp_bsbs, :sp_s_qymc, :string unless column_exists? :sp_bsbs, :sp_s_qymc
    add_column :sp_bsbs, :sp_s_qydz, :string unless column_exists? :sp_bsbs, :sp_s_qydz
    add_column :sp_bsbs, :sp_s_qs, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_qs
    add_column :sp_bsbs, :sp_s_lxr, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_lxr
    add_column :sp_bsbs, :sp_s_tel, :string, :limit => 32 unless column_exists? :sp_bsbs, :sp_s_tel
    add_column :sp_bsbs, :sp_s_pic, :text unless column_exists? :sp_bsbs, :sp_s_pic
    add_column :sp_bsbs, :sp_s_sign, :text unless column_exists? :sp_bsbs, :sp_s_sign
    add_column :sp_bsbs, :health_code, :string unless column_exists? :sp_bsbs, :health_code
    add_column :sp_bsbs, :health_func_cat, :text unless column_exists? :sp_bsbs, :health_func_cat
    add_column :sp_bsbs, :barcode, :string, :limit => 13 unless column_exists? :sp_bsbs, :barcode
    add_column :sp_bsbs, :rainbowcode, :string, :limit => 12 unless column_exists? :sp_bsbs, :rainbowcode
    add_column :sp_bsbs, :rainbowcode_url, :string unless column_exists? :sp_bsbs, :rainbowcode_url
  end
end
