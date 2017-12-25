/*$(function(){
    //console.log(getTimeline());

})*/
// 图表展示

    var anhui_data={'s':[[80,20],[120,40],[100,30],[70,20],[90,10],[60,40],[100,20]],'x':['人民食堂','食品网','食品企业','大众超市'],'datas':[{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[34,46,47,49],
        '20171':[34,46,47,49],
        '20172':[34,46,47,49]
    },{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[134,146,147,149],
        '20171':[304,146,247,349],
        '20172':[434,246,147,149]
    },{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[134,146,147,149],
        '20171':[304,406,407,409],
        '20172':[334,246,47,49]
    },{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[134,146,147,149],
        '20171':[304,416,427,409],
        '20172':[340,146,427,439]
    },{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[340,146,147,149],
        '20171':[240,360,270,149],
        '20172':[134,146,147,149]
    },{
        '20168':[500,42,20,115],
        '20169':[48,34,40,40],
        '201610':[39,42,45,49],
        '201611':[34,46,47,49],
        '201612':[134,146,147,149],
        '20171':[240,460,237,349],
        '20172':[123,246,347,409]
    }]};
    var anhui_data1={'s':[[80,20],[120,40],[100,30],[70,20],[90,10],[60,40],[100,20]],'x':['人民食堂','人民食堂1','食品网','食品企业','大众超市','大众超市2'],'datas':[{
        '20168':[500,42,20,115,200,80],
        '20169':[48,34,40,40,120,40],
        '201610':[39,42,45,49,300,150],
        '201611':[34,46,47,49,100,80],
        '201612':[34,46,47,49,400,200],
        '20171':[34,46,47,49,500,200],
        '20172':[34,46,47,49,150,40]
    },{
        '20168':[500,42,20,115,80,90],
        '20169':[48,34,40,40,120,110],
        '201610':[39,42,45,49,300,200],
        '201611':[34,46,47,49,150,180],
        '201612':[134,146,147,149,200,100],
        '20171':[304,146,247,349,50,200],
        '20172':[434,246,147,149,100,60]
    },{
        '20168':[500,42,20,115,100,90],
        '20169':[48,34,40,40,400,300],
        '201610':[39,42,45,49,40,400],
        '201611':[34,46,47,49,45,49],
        '201612':[134,146,147,149,46,47],
        '20171':[304,406,407,409,149,46],
        '20172':[334,246,47,49,400,100]
    },{
        '20168':[500,42,20,115,90,30],
        '20169':[48,34,40,40,115,90],
        '201610':[39,42,45,49,40,115],
        '201611':[34,46,47,49,49,40],
        '201612':[134,146,147,149,46,47],
        '20171':[304,416,427,409,149,46],
        '20172':[340,146,427,439,409,149]
    },{
        '20168':[500,42,20,115,439,409],
        '20169':[48,34,40,40,115,439],
        '201610':[39,42,45,49,40,115,],
        '201611':[34,46,47,49,49,40,],
        '201612':[340,146,147,149,49,49],
        '20171':[240,360,270,149,149,49],
        '20172':[134,146,147,149,270,149]
    },{
        '20168':[500,42,20,115,149,270],
        '20169':[48,34,40,40,115,149],
        '201610':[39,42,45,49,40,115],
        '201611':[34,46,47,49,49,40],
        '201612':[134,146,147,149,47,49],
        '20171':[240,460,237,349,149,47],
        '20172':[123,246,347,409,349,149]
    }]};

function chart(){
    var myChart=echarts.init(document.getElementById('chart'));
    //getCharData(data);
    // 点击查询
    $('#checkBtn').bind('click',function(){
        var time = $("#time").val();
        if(time==""){
            alert("请选择时间");
            return
        }
        if($(".exportR").hasClass("hide")) {
            myChart.showLoading();
            /*  $.ajax({
             type : "post",
             async : true, //异步执行
             url : "",
             dataType : "json", //返回数据形式为json
             data:{
                time:time.replace(/\ +/g,""),
                hj:$('#hj').val(),
                area:$('#cqtj_option').val()
             },
             success : function(json) {
             if (json) {
             if(json){
                 var option=getCharData(json);
                 myChart.setOption(option);
                 myChart.hideLoading();
             }else{
             alert('数据错误');
             },
             error : function(){
             alert('数据错误');
             }*/
            var option = getCharData(anhui_data);
            myChart.setOption(option);
            myChart.hideLoading();
        }else{
            /*  $.ajax({
             type : "post",
             async : true, //异步执行
             url : "",
             dataType : "json", //返回数据形式为json
             data:{
                 time:time.replace(/\ +/g,""),
                 hj:$('#hj').val(),
                 area:$('#cqtj_option').val()
             },
             success : function(json) {
             if (json) {
             if(json){
                 $('#tb_report').bootstrapTable('destroy');
                 getData(json);
             }else{
             alert('数据错误');
             },
             error : function(){
             alert('数据错误');
             }*/
        }
    })


// 获取数据
function getCharData(data){
    var dataMap = {};
    // 获取时间轴数据
   /* var startT=getTimeline().startT;
    var endT=getTimeline().endT;
    var startY=getTimeline().startY;
    var endY=getTimeline().endY;
    var timeLen=getTimeline().timeLen;*/
    var timeArr=getTimeline().timeArr;
    var timeArr1=getTimeline().timeArr1;
    var options=[];
    var obj={};
    dataMap.dataBHege = dataFormatter(data.datas[0],data.x,timeArr1);//不合格处置数
    dataMap.dataBuhege = dataFormatter(data.datas[1],data.x,timeArr1);//不合格处置完成数
    dataMap.dataYiyi = dataFormatter(data.datas[2],data.x,timeArr1); //异议数
    dataMap.dataFujian = dataFormatter(data.datas[3],data.x,timeArr1);//复检数
    dataMap.dataFujianbhg = dataFormatter(data.datas[4],data.x,timeArr1); //复检不合格数
    dataMap.dataLian = dataFormatter(data.datas[5],data.x,timeArr1);//立案数

    for(var i=0,len=timeArr1.length;i<len;i++){
        obj= {
            title: {text: timeArr[i]+'核查处置统计'},
            series: [
                {data: dataMap.dataBHege[timeArr1[i]]},
                {data: dataMap.dataBuhege[timeArr1[i]]},
                {data: dataMap.dataYiyi[timeArr1[i]]},
                {data: dataMap.dataFujian[timeArr1[i]]},
                {data: dataMap.dataFujianbhg[timeArr1[i]]},
                {data: dataMap.dataLian[timeArr1[i]]},
                {data: [
                    {name: '不合格处置数', value: data.s[i][0]},
                    {name: '不合格处置完成数', value: data.s[i][1]}
                ]}
            ]
        }
        options.push(obj);
    }
    var option = {
        baseOption: {
            timeline: {
                axisType: 'category',
                autoPlay: true,
                playInterval: 1000,
                data: timeArr
            },
            tooltip: {
            },
            legend: {
                x: 'right',
                data: ['不合格处置数', '不合格处置完成数', '异议数', '复检数', '复检不合格数', '立案数']
            },
            calculable : true,
            grid: {
                top: 80,
                bottom: 100,
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow',
                        label: {
                            show: true,
                            formatter: function (params) {
                                return params.value.replace('\n', '');
                            }
                        }
                    }
                }
            },
            xAxis: [
                {
                    'type':'category',
                    'axisLabel':{'interval':0},
                    'data':data.x,
                    splitLine: {show: false}
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    name: '数量（件）'
                }
            ],
            series: [
                {name: '不合格处置数', type: 'bar'},
                {name: '不合格处置完成数', type: 'bar'},
                {name: '异议数', type: 'bar'},
                {name: '复检数', type: 'bar'},
                {name: '复检不合格数', type: 'bar'},
                {name: '立案数', type: 'bar'},
                {
                    name: '不合格处置数占比',
                    type: 'pie',
                    center: ['82%', '28%'],
                    radius: '28%',
                    z: 100
                }
            ]
        },
        options: options
    };
    return option;
}
}
// 图表数据处理
function dataFormatter(obj,plist,timeline) {
    var pList = plist;
    var temp;
    var arr=timeline;
    for (var mounth = 0; mounth < arr.length; mounth++) {
        var max = 0;
        var sum = 0;
        temp = obj[arr[mounth]];
        for (var i = 0, l = temp.length; i < l; i++) {
            obj[arr[mounth]][i] = {
                name : pList[i],
                value : temp[i]
            }
        }
    }
    return obj;
}

// 获取时间轴数据
function getTimeline(){
    var time = $("#time").val().replace(/\ +/g,"");
    var timeS = time.split('/')[0];
    var timeE = time.split('/')[1];
    console.log(timeS);
    console.log(timeE);
    var startT=timeS.split('-')[1]-0;
    var endT=timeE.split('-')[1]-0;
    var startY=timeS.split('-')[0]-0;
    var endY=timeE.split('-')[0]-0;
    var timeLen=endY-startY==0?endT-startT:12-startT+endT;
    var timeArr=[];
    var timeArr1=[];
    var nowM=0,nowY=0,num=0;
    for(var i=0;i<=timeLen;i++){
        if(startT+i>12){
            nowM=++num;
            nowY=startY+1;
        } else{
            nowM=startT+i;
            nowY=startY;
        }
        timeArr.push(nowY+'年'+nowM+'月');
        timeArr1.push(nowY+''+nowM);
    }
    var timeObj={'startT':startT,'endT':endT,'startY':startY,'endY':endY,'timeLen':timeLen,'timeArr':timeArr,'timeArr1':timeArr1};
    return timeObj;
}

// 点击切换图表
function changeBtn(){
    $('#changeBtn').click(function(event) {
        var that=$(this);
        $('.content_bottom').toggleClass('hide');
        $('.charts_1').toggleClass('hide');
        if($('.content_bottom').is(':hidden')){
            that.text('切换表格模式');
             $('.exportR').addClass('hide');
        }else{
            that.text('切换图表模式');
             $('.exportR').removeClass('hide');
        }
    });

}