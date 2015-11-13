#encoding=UTF-8
class HzpBcDw < ActiveRecord::Base
    attr_accessible :dwdq, :dwdz, :dwfr, :dwfrdh, :dwfzr, :dwfzrdh, :dwlx, :dwlxzdy,:dwname, :dwsf, :dwxs, :dwxz, :dwyb
    OPTIONS1=[
        {:name=>'生产企业',:id=>'生产企业'},
        {:name=>'商场',:id=>'商场'},
        {:name=>'超市',:id=>'超市'},
        {:name=>'药店',:id=>'药店'},
        {:name=>'专卖店',:id=>'专卖店'},
        {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS2=[
        {:name=>'北京',:id=>'北京'},
        {:name=>'天津',:id=>'天津'},
        {:name=>'河北省',:id=>'河北省'},
        {:name=>'山西省',:id=>'山西省'},
        {:name=>'内蒙古自治区',:id=>'内蒙古自治区'},
        {:name=>'辽宁省',:id=>'辽宁省'},
        {:name=>'吉林省',:id=>'吉林省'},
        {:name=>'黑龙江省',:id=>'黑龙江省'},
        {:name=>'上海',:id=>'上海'},
        {:name=>'江苏省',:id=>'江苏省'},
        {:name=>'浙江省',:id=>'浙江省'},
        {:name=>'安徽省',:id=>'安徽省'},
        {:name=>'福建省',:id=>'福建省'},
        {:name=>'江西省',:id=>'江西省'},
        {:name=>'山东省',:id=>'山东省'},
        {:name=>'河南省',:id=>'河南省'},
        {:name=>'湖北省',:id=>'湖北省'},
        {:name=>'湖南省',:id=>'湖南省'},
        {:name=>'广东省',:id=>'广东省'},
        {:name=>'广西壮族自治区',:id=>'广西壮族自治区'},
        {:name=>'海南省',:id=>'海南省'},
        {:name=>'重庆',:id=>'重庆'},
        {:name=>'贵州省',:id=>'贵州省'},
    ]
    OPTIONS3=[
    {:name=>'促进排铅',:id=>'促进排铅'},
    {:name=>'辅助改善记忆',:id=>'辅助改善记忆'},
    {:name=>'对化学性损伤有辅助保护功能',:id=>'对化学性损伤有辅助保护功能'},
    {:name=>'改善睡眠',:id=>'改善睡眠'},
    {:name=>'缓解视疲劳',:id=>'缓解视疲劳'},
    {:name=>'袪痤疮',:id=>'袪痤疮'},
    {:name=>'促进泌乳',:id=>'促进泌乳'},
    {:name=>'清咽,祛黄褐斑',:id=>'清咽,祛黄褐斑'},
    {:name=>'减肥',:id=>'减肥'},
    {:name=>'辅助降血压',:id=>'辅助降血压'},
    {:name=>'改善皮肤水分',:id=>'改善皮肤水分'},
    {:name=>'改善营养性贫血',:id=>'改善营养性贫血'},
    {:name=>'缓解体力疲劳',:id=>'缓解体力疲劳'},
    {:name=>'改善皮肤油份',:id=>'改善皮肤油份'},
    {:name=>'增强免疫力',:id=>'增强免疫力'},
    {:name=>'抗高缺氧耐受力',:id=>'抗高缺氧耐受力'},
    {:name=>'调节肠道菌群',:id=>'调节肠道菌群'},
    {:name=>'辅助降血脂',:id=>'辅助降血脂'},
    {:name=>'对辐射危害有辅助保护功能',:id=>'对辐射危害有辅助保护功能'},
    {:name=>'促进消化',:id=>'促进消化'},
    {:name=>'辅助降血糖',:id=>'辅助降血糖'},
    {:name=>'改善生长发育',:id=>'改善生长发育'},
    {:name=>'通便',:id=>'通便'},
    {:name=>'抗氧化',:id=>'抗氧化'},
    {:name=>'增加骨密度',:id=>'增加骨密度'},
    {:name=>'对胃粘膜有辅助保护功能',:id=>'对胃粘膜有辅助保护功能'},
    ]
    OPTIONS4=[
    {:name=>'风险监测',:id=>'风险监测'},   
    {:name=>'监督抽检',:id=>'监督抽检'},
    {:name=>'专项抽检',:id=>'专项抽检'},
    {:name=>'常规检验',:id=>'常规检验'},
    {:name=>'委托检验',:id=>'委托检验'},
    ]
    OPTIONS5=[
    {:name=>'进口',:id=>'进口'},
    {:name=>'国产',:id=>'国产'},
    ]
    OPTIONS6=[
    {:name=>'省（区）级',:id=>'省（区）级'},
    {:name=>'地（市、州、盟）级',:id=>'地（市、州、盟）级'},
    {:name=>'县（市、区）级',:id=>'县（市、区）级'},
    ]
    OPTIONS7=[
    {:name=>'风险监测',:id=>'风险监测'},
    {:name=>'产品质量标准考察',:id=>'产品质量标准考察'},
    {:name=>'非法添加考察',:id=>'非法添加考察'},
    {:name=>'风险物质考察',:id=>'风险物质考察'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS8=[
    {:name=>'理化',:id=>'理化'},
    {:name=>'微生物',:id=>'微生物'},
    {:name=>'功效成分',:id=>'功效成分'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS9=[
    {:name=>'合格',:id=>'合格'},
    {:name=>'不合格',:id=>'不合格'},
    {:name=>'超标',:id=>'超标'},
    {:name=>'未超标',:id=>'未超标'},
    ]
    OPTIONS10=[
    {:name=>'件',:id=>'件'},
    {:name=>'箱',:id=>'箱'},
    ]
    
    OPTIONS11=[
    {:name=>'护肤类(面膜)',:id=>'护肤类(面膜)'},
    {:name=>'护肤类(洗面)',:id=>'护肤类(洗面)'},
    {:name=>'护肤类(抗皱/抗衰老)',:id=>'护肤类(抗皱/抗衰老)'},
    {:name=>'护肤类(洗浴)',:id=>'护肤类(洗浴)'},
    {:name=>'护肤类(爽身粉)',:id=>'护肤类(爽身粉)'},
    {:name=>'护肤类(祛痘/抗粉刺)',:id=>'护肤类(祛痘/抗粉刺)'},
    {:name=>'发用类(去屑)',:id=>'发用类(去屑)'},
    {:name=>'彩妆类(护唇及唇彩)',:id=>'彩妆类(护唇及唇彩)'},
    {:name=>'彩妆类(胭脂)',:id=>'彩妆类(胭脂)'},
    {:name=>'指甲类,祛斑类',:id=>'指甲类,祛斑类'},
    {:name=>'防晒类,染发类',:id=>'防晒类,染发类'},
    {:name=>'烫发类,脱毛类',:id=>'烫发类,脱毛类'},
    {:name=>'育发类,除臭类',:id=>'育发类,除臭类'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS12=[
    {:name=>'监督抽检',:id=>'监督抽检'},
    {:name=>'风险监测',:id=>'风险监测'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS13=[
    {:name=>'国产特殊',:id=>'国产特殊'},
    {:name=>'国产非特殊',:id=>'国产非特殊'},
    {:name=>'进口特殊',:id=>'进口特殊'},
    {:name=>'进口非特殊',:id=>'进口非特殊'},
    ]
    OPTIONS14=[
    {:name=>'特大型餐馆',:id=>'特大型餐馆'},
    {:name=>'大型餐馆',:id=>'大型餐馆'},
    {:name=>'中型餐馆',:id=>'中型餐馆'},
    {:name=>'小型餐馆',:id=>'小型餐馆'},
    {:name=>'机关食堂',:id=>'机关食堂'},
    {:name=>'学校/托幼食堂',:id=>'学校/托幼食堂'},
    {:name=>'企事业单位食堂',:id=>'企事业单位食堂'},
    {:name=>'建筑工地食堂',:id=>'建筑工地食堂'},
    {:name=>'小吃店',:id=>'小吃店'},
    {:name=>'快餐店',:id=>'快餐店'},
    {:name=>'饮品店',:id=>'饮品店'},
    {:name=>'集体用餐配送单位',:id=>'集体用餐配送单位'},
    {:name=>'中央厨房',:id=>'中央厨房'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS15=[
    {:name=>'水果及制品',:id=>'水果及制品'},
    {:name=>'坚果和籽类',:id=>'坚果和籽类'},
    {:name=>'新鲜蔬菜',:id=>'新鲜蔬菜'},
    {:name=>'加工蔬菜',:id=>'加工蔬菜'},
    {:name=>'食用菌和藻类',:id=>'食用菌和藻类'},
    {:name=>'豆类制品',:id=>'豆类制品'},
    {:name=>'肉及肉制品',:id=>'肉及肉制品'},
    {:name=>'水产及其制品',:id=>'水产及其制品'},
    {:name=>'蛋及蛋制品',:id=>'蛋及蛋制品'},
    {:name=>'乳及乳制品',:id=>'乳及乳制品'},
    {:name=>'酒类',:id=>'酒类'},
    {:name=>'饮料类',:id=>'饮料类'},
    {:name=>'粮食及制品',:id=>'粮食及制品'},
    {:name=>'脂肪、油和乳化脂肪制品',:id=>'脂肪、油和乳化脂肪制品'},
    {:name=>'调味品',:id=>'调味品'},
    {:name=>'食品添加剂',:id=>'食品添加剂'},
    {:name=>'冷冻饮品',:id=>'冷冻饮品'},
    {:name=>'可可制品、巧克力及制品',:id=>'可可制品、巧克力及制品'},
    {:name=>'餐饮具',:id=>'餐饮具'},
    {:name=>'加工器具',:id=>'加工器具'},
    {:name=>'一次性包装材料',:id=>'一次性包装材料'},
    {:name=>'清洁具',:id=>'清洁具'},
    {:name=>'环境卫生',:id=>'环境卫生'},
    {:name=>'人员及防护用具',:id=>'人员及防护用具'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS16=[
    {:name=>'固体',:id=>'固体'},
    {:name=>'半固体',:id=>'半固体'},
    {:name=>'液体',:id=>'液体'},
    {:name=>'半液体',:id=>'半液体'},
    {:name=>'气体',:id=>'气体'},
    ]
    OPTIONS17=[
    {:name=>'原料',:id=>'原料'},
    {:name=>'半成品',:id=>'半成品'},
    {:name=>'成品',:id=>'成品'},
    {:name=>'污染物',:id=>'污染物'},
    ]
    OPTIONS18=[
    {:name=>'散装',:id=>'散装'},
    {:name=>'预包装',:id=>'预包装'},
    ]
    OPTIONS19=[
    {:name=>'原材料购置',:id=>'原材料购置'},
    {:name=>'加工前贮存',:id=>'加工前贮存'},
    {:name=>'加工',:id=>'加工'},
    {:name=>'加工成品、半成品',:id=>'加工成品、半成品'},
    {:name=>'加工后储藏',:id=>'加工后储藏'},
    {:name=>'服务',:id=>'服务'},
    ]
    OPTIONS20=[
    {:name=>'自制',:id=>'自制'},
    {:name=>'外购',:id=>'外购'},
    {:name=>'委托生产',:id=>'委托生产'},
    {:name=>'污染',:id=>'污染'},
    ]
    OPTIONS21=[
    {:name=>'无菌采样',:id=>'无菌采样'},
    {:name=>'非无菌采样',:id=>'非无菌采样'},
    ]
    OPTIONS22=[
    {:name=>'常温',:id=>'常温'},
    {:name=>'冷藏',:id=>'冷藏'},
    {:name=>'冷冻',:id=>'冷冻'},
    {:name=>'避光',:id=>'避光'},
    {:name=>'密闭',:id=>'密闭'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS23=[
    {:name=>'玻璃瓶',:id=>'玻璃瓶'},
    {:name=>'塑料瓶',:id=>'塑料瓶'},
    {:name=>'塑料袋',:id=>'塑料袋'},
    {:name=>'无菌袋',:id=>'无菌袋'},
    {:name=>'其他',:id=>'其他'},
    ]
    OPTIONS24=[
    {:name=>'监督抽检',:id=>'监督抽检'},
    {:name=>'调查评价',:id=>'调查评价'},
    {:name=>'其他',:id=>'其他'},
    ]

    


    

    def self.options1
        OPTIONS1.map{|option|[option[:name],option[:id]]}
    end
    def self.options2
        OPTIONS2.map{|option|[option[:name],option[:id]]}
    end
    def self.options3
        OPTIONS3.map{|option|[option[:name],option[:id]]}
    end
    def self.options4
        OPTIONS4.map{|option|[option[:name],option[:id]]}
    end
    def self.options5
        OPTIONS5.map{|option|[option[:name],option[:id]]}
    end
    def self.options6
        OPTIONS6.map{|option|[option[:name],option[:id]]}
    end
    def self.options7
        OPTIONS7.map{|option|[option[:name],option[:id]]}
    end
    def self.options8
        OPTIONS8.map{|option|[option[:name],option[:id]]}
    end
    def self.options9
        OPTIONS9.map{|option|[option[:name],option[:id]]}
    end
    def self.options10
        OPTIONS10.map{|option|[option[:name],option[:id]]}
    end
    def self.options11
        OPTIONS11.map{|option|[option[:name],option[:id]]}
    end
    def self.options12
        OPTIONS12.map{|option|[option[:name],option[:id]]}
    end
    def self.options13
        OPTIONS13.map{|option|[option[:name],option[:id]]}
    end
    def self.options14
        OPTIONS14.map{|option|[option[:name],option[:id]]}
    end
    def self.options15
        OPTIONS15.map{|option|[option[:name],option[:id]]}
    end
    def self.options16
        OPTIONS16.map{|option|[option[:name],option[:id]]}
    end

    def self.options17
        OPTIONS17.map{|option|[option[:name],option[:id]]}
    end

    def self.options18
        OPTIONS18.map{|option|[option[:name],option[:id]]}
    end

    def self.options19
        OPTIONS19.map{|option|[option[:name],option[:id]]}
    end

    def self.options20
        OPTIONS20.map{|option|[option[:name],option[:id]]}
    end

    def self.options21
        OPTIONS21.map{|option|[option[:name],option[:id]]}
    end

    def self.options22
        OPTIONS22.map{|option|[option[:name],option[:id]]}
    end

    def self.options23
        OPTIONS23.map{|option|[option[:name],option[:id]]}
    end

    def self.options24
        OPTIONS24.map{|option|[option[:name],option[:id]]}
    end




end
