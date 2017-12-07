class Statistic < ActiveRecord::Base
  Task = ["区域","任务数","抽样数","检验数","不合格数","合格数","已处置","处置中"] 
  Food = ["名称", "序号", "任务数", "抽样数", "检验数", "不合格数", "合格数", "已处置", "处置中"]
  Nonconformity = ["市","检验不合格项目","不合格批次"]
  Unit = ["地区", "序号", "任务数", "接样数", "合格数", "不合格数", "已处置", "处置中"]
  Overtime = ["抽样单位","天数"]
  Disposal = ["序号", "处置单位", "处置环节", "不合格处置数", "不合格处置率", "不合格处置完成数", "不合格处置完成率", "异议数", "复检数", "复检不合格数", "立案数"]
  Enterprise = ["序号", "区域", "总企业数", "被抽样单位数", "覆盖率"]
  EarlyWarning = ["序号", "区域", "被抽样单位", "生产企业", "样品名称", "任务来源", "报送分类a", "报送分类b", "大类", "次亚类", "亚类", "细类"]
  Composite = ["地区", "序号", "总批次", "监督抽检批次", "合格批次", "不合格批次", "不合格样品率", "风险检测批次", "问题样品批次", "问题样品率"]
end