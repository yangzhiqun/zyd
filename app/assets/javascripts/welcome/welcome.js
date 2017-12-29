$(function(){
   var data = JSON.parse($('#data').val());
   var info = JSON.parse($('#info').val());
   var info2 = JSON.parse($('#info2').val());
   var info3 = JSON.parse($('#info3').val());
    charts(data);
    getDataTp(info);
    getData2(info2);
    getData3(info3);
})
function randomData() {
    return Math.round(Math.random()*1000);
}
var data = {"sc":[],"lt":[],"cy":[]};
/*var data = {"sc":[
>>>>>>> 97a089e570f86a3f4960f358e016d1f6c663436a
    {name: '合肥市',value: randomData() },
    {name: '芜湖市',value: randomData() },
    {name: '蚌埠市',value: randomData() },
    {name: '淮北市',value: randomData() },
    {name: '马鞍山市',value: randomData() },
    {name: '淮南市',value: randomData() },
    {name: '铜陵市',value: randomData() },
    {name: '安庆市',value: randomData() },
    {name: '黄山市',value: randomData() },
    {name: '滁州市',value: randomData() },
    {name: '宿州市',value: randomData() },
    {name: '阜阳市',value: randomData() },
    {name: '六安市',value: randomData() },
    {name: '亳州市',value: randomData() },
    {name: '池州市',value: randomData() },
    {name: '宣城市',value: randomData() }
],"lt":[
    {name: '安庆市',value: randomData() },
    {name: '黄山市',value: randomData() },
    {name: '滁州市',value: randomData() },
    {name: '宿州市',value: randomData() },
    {name: '阜阳市',value: randomData() }
],"cy":[
    {name: '芜湖市',value: randomData() },
    {name: '蚌埠市',value: randomData() },
    {name: '淮北市',value: randomData() },
    {name: '马鞍山市',value: randomData() },
    {name: '淮南市',value: randomData() },
    {name: '铜陵市',value: randomData() },
    {name: '安庆市',value: randomData() },
    {name: '黄山市',value: randomData() },
    {name: '滁州市',value: randomData() },
    {name: '宿州市',value: randomData() },
    {name: '阜阳市',value: randomData() }
]};*/
function charts(data){
      var option = {
            title: {
                text: '安徽省各地市抽检信息汇总',
                left: 'center'
            },tooltip: {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data:['生产','流通','餐饮']

            },
            visualMap: {
                min: 0,
                max: 2500,
                left: 'left',
                top: 'bottom',
                text: ['高','低'],           // 文本，默认为数值文本
                calculable: true,
                color: ['orangered','yellow','lightskyblue']
            },
            toolbox: {
                show: true,
                orient: 'vertical',
                left: 'right',
                top: 'center',
                feature: {
                    dataView: {readOnly: false},
                    restore: {},
                    saveAsImage: {}
                }
            },
            series: [{
                name: '生产',
                type: 'map',
                map: '安徽',
                mapType: '安徽',
                //roam: false,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                },
                mapLocation: {
                    x: '35%'
                },
                roam: true,
                color: ['orangered','yellow','lightskyblue'],
                data:data.sc
            },{
                name: '流通',
                type: 'map',
                map: '安徽',
                mapType: '安徽',
                //roam: false,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                },
                mapLocation: {
                    x: '35%'
                },
                roam: true,
                color: ['orangered','yellow','lightskyblue'],
                data:data.lt
            },{
                name: '餐饮',
                type: 'map',
                map: '安徽',
                mapType: '安徽',
                //roam: false,
                label: {
                    normal: {
                        show: true
                    },
                    emphasis: {
                        show: true
                    }
                }, mapLocation: {
                    x: '35%'
                },
                roam: true,
                color: ['orangered','yellow','lightskyblue'],
                data:data.cy
            }]
        };
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
    myChart.setOption(option);
    //点击事件
    myChart.on('click', function(params) {
        var url = "/welcome_notices";
        ajaxInfo(url,params.name,'0');
    });

}


var info = [{"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"滁州","bcydwmc":"明光市李玲调味品经营部","bhgyp":"鸡精调味料","bhgfl":"调味品","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"九三牌大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"宣城","bcydwmc":"宣城大润发商业有限公司","bhgyp":"冰糕","bhgfl":"糕点","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"宣城","bcydwmc":"绩溪县徽和天下食品有限公司","bhgyp":"绩溪臭鳜鱼","bhgfl":"速冻食品","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"宣城","bcydwmc":"安徽省绩溪县劳模实业有限公司","bhgyp":"红豆薏米核桃粉","bhgfl":"方便食品","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]},
    {"bcydwqy":"阜阳","bcydwmc":"阜阳华联集团股份有限公司华联大厦分公司","bhgyp":"大豆油","bhgfl":"食用油","bhgpc":[1,2,3,4,5]}];
//加载top10列表
function getDataTp(info){
    
    $('#tb_report1').bootstrapTable({
        //url: '/GroupColumns/GetReport',         //请求后台的URL（*）
        //method: 'get',                      //请求方式（*）
        data:info,
        // datatype:'json',
        toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        //search: true, //显示搜索框
         pagination: true,                   //是否显示分页（*）
        // sortOrder: "asc",                   //排序方式
        //queryParams: oTableInit.queryParams,//传递参数（*）
         sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
         pageNumber: 1,                       //初始化加载第一页，默认第一页
         pageSize: 5,                       //每页的记录行数（*）
         pageList: [5, 10],      //可供选择的每页的行数（*）
        columns : [
            {
                title : '序号',//标题  可不加
                formatter : function(value,row, index) {
                    return index + 1;
                }
            },
            {
                field : 'bcydwqy',
                title : '被抽样单位区域',
                align : 'center'
                //sortable : true 排序
            },
            {
                field : 'bcydwmc',
                title : '被抽样单位名称',
                align : 'center'
            },{
                field : 'bhgpc',
                title : '不合格批次',
                align : 'center',
                formatter : function (value, row, index) {
                    var info = "<a href='javascript:void(0);' onclick = getInfo('particulars','"+row.id+"');>"+value+"</a>";
                    return info;
                }
            }
        ]
    });
}
var info2 = [{"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"生产"},
    {"id":"123","qy":"宣城","cydh":"SC17340622222","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"},
    {"id":"123","qy":"宣城","cydh":"SC17340626352","ypmc":"红豆薏米核桃粉","bcydwmc":"安徽省绩溪县劳模实业有限公司","hj":"餐饮"}];
//
function getData2(info){

    $('#tb_report2').bootstrapTable({
        height:250,
        //url: '/GroupColumns/GetReport',         //请求后台的URL（*）
        //method: 'get',                      //请求方式（*）
        data:info,
        // datatype:'json',
        toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        //search: true, //显示搜索框
         pagination: true,                   //是否显示分页（*）
        // sortOrder: "asc",                   //排序方式
        //queryParams: oTableInit.queryParams,//传递参数（*）
         sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
         pageNumber: 1,                       //初始化加载第一页，默认第一页
         pageSize: 5,                       //每页的记录行数（*）
         pageList: [2,5],      //可供选择的每页的行数（*）
        columns : [
            {
                title : '序号',//标题  可不加
                formatter : function(value,row, index) {
                    return index + 1;
                }
            },{
                field : 'qy',
                title : '区域',
                align : 'center'
            },
            {
                field : 'cydh',
                title : '抽样单号',
                align : 'center',
                formatter : function (value, row, index) {
                    //var info = "<a href='javascript:void(0);' onclick = getInfo('particulars','"+row.id+"');>"+value+"</a>"
                    var info = "<a href='javascript:void(0);' onclick = ajaxInfo('url','"+row.id+"','1')>"+value+"</a>";
                    return info;
                }
            },
            {
                field : 'ypmc',
                title : '样品名称',
                align : 'center'
            },{
                field : 'bcydwmc',
                title : '被抽样单位名称',
                align : 'center'
            },{
                field : 'hj',
                title : '环节',
                align : 'center'
            }
        ]
    });
}
var info31 = [{"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"},
    {"qy":"合肥","jyxm":"糖精钠(以糖精计)","ypmc":"九三牌大豆油"}];
//
function getData3(info){
    $('#tb_report3').bootstrapTable({
        height:250,
        //url: '/GroupColumns/GetReport',         //请求后台的URL（*）
        //method: 'get',                      //请求方式（*）
        data:info,
        // datatype:'json',
        toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        //search: true, //显示搜索框
        pagination: true,                   //是否显示分页（*）
        // sortOrder: "asc",                   //排序方式
        //queryParams: oTableInit.queryParams,//传递参数（*）
        sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
        pageNumber: 1,                       //初始化加载第一页，默认第一页
        pageSize: 5,                       //每页的记录行数（*）
        pageList: [2,5],      //可供选择的每页的行数（*）
        columns : [
            {
                title : '序号',//标题  可不加
                formatter : function(value,row, index) {
                    return index + 1;
                }
            },{
                field : 'qy',
                title : '区域',
                align : 'center'
            },
            {
                field : 'jyxm',
                title : '检验项目',
                align : 'center'
            },{
                field : 'ypmc',
                title : '样品名称',
                align : 'center'
           }
        ]
    });
}
/**
 *
 * @param url 后台url
 * @param params 参数
 * @param flag 类型 0，点击地图；1，点击抽样编号
 */
function ajaxInfo(url,params,flag){

     $.ajax({
     type : "post",
     async : true, //异步执行
     url : url,
     data : {"name": params},
     dataType : 'json', //返回数据形式为json
     success : function(json) {
         if(flag=='1'){
         //先销毁表格
         $('#tb_report2').bootstrapTable('destroy');
         $('#tb_report3').bootstrapTable('destroy');
             getData2(json);
             getData3(json);
         }else if(flag=='2'){
         $('#tb_report3').bootstrapTable('destroy');
             getData3(json);
         }else if(flag =='0'){
          //$("#map").html(json.info,json.info2,json.info3,json.data); 
          $('#tb_report1').bootstrapTable('destroy');
          $('#tb_report2').bootstrapTable('destroy');
          $('#tb_report3').bootstrapTable('destroy');
          getDataTp(JSON.parse(json.info));
          getData2(JSON.parse(json.info2));
          getData3(JSON.parse(json.info3));
         } 
     },
     error:function(XMLHttpRequest, textStatus, errorThrown){
        alert('加载数据失败');
     }
  });
} 

function getInfo(url,id){
   var tempForm = document.createElement("form");
   tempForm.id = "tempForm1";
   tempForm.method = "post";
   tempForm.action = url;
   tempForm.target="_blank"; //打开新页面
   var hideInput1 = document.createElement("input");
    hideInput1.type = "hidden";
    hideInput1.name="opid"; //后台要接受这个参数来取值
    hideInput1.value = id; //后台实际取到的值
    tempForm.appendChild(hideInput1);
   if(document.all){
     tempForm.attachEvent("onsubmit",function(){});        //IE
   }else{
     var subObj = tempForm.addEventListener("submit",function(){},false);    //firefox
   }
     document.body.appendChild(tempForm);
   if(document.all){
     tempForm.fireEvent("onsubmit");
   }else{
      tempForm.dispatchEvent(new Event("submit"));
    }
      tempForm.submit();
     document.body.removeChild(tempForm);
 
}

//请求后台方法，弹出详情页面
function openPostWindow(data){
    var tempForm = document.createElement("form");
    tempForm.id = "tempForm1";
    tempForm.method = "post";
    tempForm.action = "particulars";
    tempForm.target="_blank"; //打开新页面
    var hideInput1 = document.createElement("input");
    hideInput1.type = "hidden";
    hideInput1.name="opid"; //后台要接受这个参数来取值
    hideInput1.value = data; //后台实际取到的值
    /*var hideInput2 = document.createElement("input");
     hideInput2.type = "hidden";
     hideInput2.name="xtmc";
     hideInput2.value = data2;  这里就是如果需要第二个参数的时候可以自己再设置*/
    tempForm.appendChild(hideInput1);
    //tempForm.appendChild(hideInput2);
    if(document.all){
        tempForm.attachEvent("onsubmit",function(){});        //IE
    }else{
        var subObj = tempForm.addEventListener("submit",function(){},false);    //firefox
    }
    document.body.appendChild(tempForm);
    if(document.all){
        tempForm.fireEvent("onsubmit");
    }else{
        tempForm.dispatchEvent(new Event("submit"));
    }
    tempForm.submit();
    document.body.removeChild(tempForm);
}
