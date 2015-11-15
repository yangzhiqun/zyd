#encoding=UTF-8
class HzpYpb < ActiveRecord::Base
  #attr_accessible :dwname, :ypflei, :ypleib, :ypleibzdy, :ypname, :ypno
    OPTIONS1=[
    {:name=>'国产特殊',:id=>'生产企业'},
    {:name=>'国产非特殊',:id=>'商场'},
    {:name=>'进口特殊',:id=>'超市'},
    {:name=>'进口非特殊',:id=>'药店'}
    ]
    OPTIONS2=[
    {:name=>'护肤类(面膜)',:id=>'北京'},
    {:name=>'护肤类(洗面)',:id=>'天津'},
    {:name=>'护肤类(抗皱/抗衰老)',:id=>'河北省'},
    {:name=>'护肤类(洗浴)',:id=>'山西省'},
    {:name=>'护肤类(爽身粉)',:id=>'内蒙古自治区'},
    {:name=>'其他',:id=>'辽宁省'}
    ]
    def self.options1
      OPTIONS1.map{|option|[option[:name],option[:name]]}
    end
    def self.options2
      OPTIONS2.map{|option|[option[:name],option[:name]]}
    end
end
