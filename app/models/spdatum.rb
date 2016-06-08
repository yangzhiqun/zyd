class Spdatum < ActiveRecord::Base
	# attr_accessible :spdata_0, :spdata_1, :spdata_2, :spdata_3, :spdata_4, :spdata_5, :spdata_6, :spdata_7, :spdata_8, :spdata_9, :sp_bsb_id,:spdata_10, :spdata_11, :spdata_12, :spdata_13, :spdata_14, :spdata_15, :spdata_16, :spdata_17,:spdata_18
  belongs_to :sp_bsb
  CA_FIELDS = [:spdata_0, :spdata_1, :spdata_2, :spdata_3, :spdata_4, :spdata_5, :spdata_6, :spdata_7, :spdata_8, :spdata_9, :spdata_10, :spdata_11, :spdata_12, :spdata_13, :spdata_14, :spdata_15, :spdadta_16, :spdata_17, :spdata_18]
  API_FIELDS = {
      :spdata_0 => "检验项目",
      :spdata_1 => "检验结果",
      :spdata_18 => "结果单位",
      :spdata_2 => "结果判定",
      :spdata_3 => "检验依据",
      :spdata_4 => "判定依据",
      :spdata_5 => "标准方法检出限",
      :spdata_6 => "标准检出限单位",
      :spdata_7 => "方法检出限",
      :spdata_8 => "检出限单位",
      :spdata_9 => "标准最小允许限",
      :spdata_10 => "标准最小允许限单位",
      :spdata_11 => "最小允许限",
      :spdata_12 => "最小允许限单位",
      :spdata_13 => "标准最大允许限",
      :spdata_14 => "标准最大允许限单位",
      :spdata_15 => "最大允许限",
      :spdata_16 => "最大允许限单位",
      :spdata_17 => "说明"
  }
end
