var cityMap = {
	"安徽省": "340000",
    "合肥市": "340100",
    "芜湖市": "340200",
    "蚌埠市": "340300",
    "淮南市": "340400",
    "马鞍山市": "340500",
    "淮北市": "340600",
    "铜陵市": "340700",
    "安庆市": "340800",
    "黄山市": "341000",
    "滁州市": "341100",
    "阜阳市": "341200",
    "宿州市": "341300",
    "六安市": "341500",
    "亳州市": "341600",
    "池州市": "341700",
    "宣城市": "341800"
};
function randomData() {
    return Math.round(Math.random()*50);
};

function returnData(){
var data={
    'anhui':{'yb':'340000','koh':0,'hoValue':0,'bhgxm':['酸价（KOH）','过氧化值','铅（pb）','霉菌','安赛蜜','纳他霉素'],'detail':[
    {'cityName':'合肥','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（市级本级）','bsflB':'2017年安徽抽检计划','dalei':'食品加工品','yalei':'小麦','ciyalei':'小麦粉','xilei':'通用小麦，专用小麦'},
    {'cityName':'芜湖','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级专项）','bsflB':'2017年安徽食品抽检计划','dalei':'食用油，油脂及其制品','yalei':'食用油脂制品','ciyalei':'煎炸过程用油（餐饮环节）','xilei':''},
    {'cityName':'蚌埠','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'调味品','yalei':'其他粮食制品','ciyalei':'','xilei':''},
    {'cityName':'淮北','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'肉制品','yalei':'使用动物油脂','ciyalei':'','xilei':''}
    ]},
    'hefei':{'yb':'340100','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['酸价（KOH）','铅（pb）'],'detail':[
    {'cityName':'长丰县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（市级本级）','bsflB':'2017年安徽抽检计划','dalei':'食品加工品','yalei':'小麦','ciyalei':'小麦粉','xilei':'通用小麦，专用小麦'},
    {'cityName':'肥西县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级专项）','bsflB':'2017年安徽食品抽检计划','dalei':'食用油，油脂及其制品','yalei':'食用油脂制品','ciyalei':'煎炸过程用油（餐饮环节）','xilei':''},
    {'cityName':'肥东县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'调味品','yalei':'其他粮食制品','ciyalei':'','xilei':''},
    {'cityName':'庐江县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'肉制品','yalei':'使用动物油脂','ciyalei':'','xilei':''}
    ]},
    'wuhu':{'yb':'340200','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['铅（pb）','过氧化值'],'detail':[
    {'cityName':'无为县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（市级本级）','bsflB':'2017年安徽抽检计划','dalei':'食品加工品','yalei':'小麦','ciyalei':'小麦粉','xilei':'通用小麦，专用小麦'},
    {'cityName':'三山区','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级专项）','bsflB':'2017年安徽食品抽检计划','dalei':'食用油，油脂及其制品','yalei':'食用油脂制品','ciyalei':'煎炸过程用油（餐饮环节）','xilei':''},
    {'cityName':'芜湖县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'调味品','yalei':'其他粮食制品','ciyalei':'','xilei':''},
    {'cityName':'鸠江区','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'肉制品','yalei':'使用动物油脂','ciyalei':'','xilei':''}
    ]},
    'bengbu':{'yb':'340300','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['铅（pb）','安赛蜜'],'detail':[
    {'cityName':'固镇县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（市级本级）','bsflB':'2017年安徽抽检计划','dalei':'食品加工品','yalei':'小麦','ciyalei':'小麦粉','xilei':'通用小麦，专用小麦'},
    {'cityName':'怀远县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级专项）','bsflB':'2017年安徽食品抽检计划','dalei':'食用油，油脂及其制品','yalei':'食用油脂制品','ciyalei':'煎炸过程用油（餐饮环节）','xilei':''},
    {'cityName':'淮上区','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'调味品','yalei':'其他粮食制品','ciyalei':'','xilei':''},
    {'cityName':'五河县','bcydw':'大众超市','scqy':'食品企业','ypmc':'面包','rwly':'管理局','bsflA':'抽检监测（省级转移）','bsflB':'2017年安徽抽检计划','dalei':'肉制品','yalei':'使用动物油脂','ciyalei':'','xilei':''}
    ]},
    'huainan':{'yb':'340400','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['铅（pb）','纳他霉素']},
    'maanshan':{'yb':'340500','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['霉菌','安赛蜜']},
    'huaibei':{'yb':'340600','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['酸价（KOH）','过氧化值']},
    'tongling':{'yb':'340700','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['铅（pb）','安赛蜜']},
    'anqing':{'yb':'340800','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['铅（pb）','酸价（KOH）']},
    'huangshan':{'yb':'341000','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['霉菌','酸价（KOH）']},
    'chuzhou':{'yb':'341100','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['霉菌','铅（pb）']},
    'fuyang':{'yb':'341200','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['过氧化值','铅（pb）']},
    'suzhou':{'yb':'341300','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['过氧化值','安赛蜜']},
    'luan':{'yb':'341500','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['过氧化值','安赛蜜']},
    'bozhou':{'yb':'341600','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['过氧化值','安赛蜜']},
    'chizhou':{'yb':'341700','koh':randomData(),'hoValue':randomData(),'count':0,'bhgxm':['过氧化值','安赛蜜']},
    'xuancheng':{'yb':'341800','koh':111,'hoValue':222,'count':0,'bhgxm':['过氧化值','安赛蜜']}
};    
    var countKoh=0,countHoValue=0;
    for(var k in data){
        data[k].koh=data[k].koh;
        data[k].hoValue=data[k].hoValue;
        data[k].count=data[k].koh+data[k].hoValue;
        countKoh+=data[k].koh;
        countHoValue+=data[k].hoValue;
    }
    data['anhui'].koh=countKoh;
    data['anhui'].hoValue=countHoValue;
    return data;
}
