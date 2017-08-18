class AddWcPadSpBsb < ActiveRecord::Migration
  def change
     add_column :pad_sp_bsbs, :sp_s_dwwz, :text unless column_exists? :pad_sp_bsbs, :sp_s_dwwz # 网店网址
     add_column :pad_sp_bsbs, :sp_s_wcmc, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcmc #网络平台名称
     add_column :pad_sp_bsbs, :sp_s_wcyyzzh, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcyyzzh #平台营业执照号
     add_column :pad_sp_bsbs, :sp_s_wcicp, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcicp #入网许可证号或ICP经营许可证
     add_column :pad_sp_bsbs, :sp_s_wcsheng, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcsheng #网抽平台所在地省
     add_column :pad_sp_bsbs, :sp_s_wcshi, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcshi # 网抽平台所在地市
     add_column :pad_sp_bsbs, :sp_s_wcxian, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcxian #网抽平台所在地县
     add_column :pad_sp_bsbs, :sp_s_wcdz, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcdz #平台地址
     add_column :pad_sp_bsbs, :sp_s_wcwz, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcwz #平台网址
     add_column :pad_sp_bsbs, :sp_s_wclxr, :string unless column_exists? :pad_sp_bsbs,:sp_s_wclxr #平台联系人
     add_column :pad_sp_bsbs, :sp_s_wctel, :string unless column_exists? :pad_sp_bsbs,:sp_s_wctel # 平台联系电话
     add_column :pad_sp_bsbs, :sp_s_wcbh, :string unless column_exists? :pad_sp_bsbs,:sp_s_wcbh #平台订单编号

  end
end
