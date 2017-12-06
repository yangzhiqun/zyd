$(function(){
    chart(datainfo1);
})
// function randomData1(){
//     return Math.round(Math.random()*250);
// }
// function randomData2(){
//     return Math.round(Math.random()*100);
// }
// function dataCount(n){
//     var data1=[];
//     var data2=[];
//     for(var i=0;i<n;i++){
//         data1.push(randomData1());
//         data2.push(randomData1()-randomData2());
//     }
//     return {'data1':data1,'data2':data2};
// }
var datainfo1 = {"cyjg":{"x":['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],"y1":[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140],"y2":[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]},
"cjjg":{"x":['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],"y1":[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140],"y2":[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]}};
// 图表展示
function chart(data){
    // Security Trends
    var option1 = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            }
        },
        toolbox: {
            feature: {
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        legend: {
            data:['完全提交退修数','完全提交退修率']
        },
        xAxis: [
            {
                type: 'category',
                data: data.cyjg.x,
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '完全提交退修数',
                min: 0,
               // max: 250,
                interval: 50,
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {
                type: 'value',
                name: '完全提交退修率',
                min: 0,
                max: 100,
                interval: 5,
                axisLabel: {
                    formatter: '{value} %'
                }
            }
        ],
        series: [
            {
                name:'完全提交退修数',
                type:'bar',
                data:data.cyjg.y1
            },
            {
                name:'完全提交退修率',
                type:'line',
                yAxisIndex: 1,
                data:data.cyjg.y2
            }
        ]
    };

    var myChart1=echarts.init(document.getElementById('chart_1'))
    myChart1.setOption(option1);
    var option2 = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            }
        },
        toolbox: {
            feature: {
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        legend: {
            data:['完全提交退修数','完全提交退修率']
        },
        xAxis: [
            {
                type: 'category',
                data:data.cjjg.x,
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '完全提交退修数',
                min: 0,
                max: 250,
                interval: 50,
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {
                type: 'value',
                name: '完全提交退修率',
                min: 0,
                max: 100,
                interval: 5,
                axisLabel: {
                    formatter: '{value} %'
                }
            }
        ],
        series: [
            {
                name:'完全提交退修数',
                type:'bar',
                data:data.cjjg.y1
            },
            {
                name:'完全提交退修率',
                type:'line',
                yAxisIndex: 1,
                data:data.cjjg.y2
            }
        ]
    };
    var myChart2=echarts.init(document.getElementById('chart_2'));
    myChart2.setOption(option2);

    //根据相应地区的数据

    $(document).on('change','#cqtj_option',function(){
        var optVal=$(this).val();
        alert(optVal);
        getChartInfo(myChart1);
        getChartInfo(myChart2);
        });
    //点击不同的市显示该市下级市县区相应的数据
    myChart1.on('click',function(params){
        // console.log(params.componentType);
        // 获取当前点击的市
        getChartInfo(this,params.name);

    });


    myChart2.on('click',function (params) {
        getChartInfo(this,params.name);
    })
    //封装点击不同的市显示当前市下级数据
    //function cityClick(myChart,data){
    //    myChart.setOption(data);
    //}


//数据请求后台
function getChartInfo(myChart,params){
    myChart.showLoading();
    /*  $.ajax({
     type : "post",
     async : true, //异步执行
     url : "AcceptData",
     dataType : "json", //返回数据形式为json
     success : function(json) {
     if (json) {
    var data;
    if(myChart==myChart1){
        data = json.cyjg;
    }else{
        data = json.cjjg;
    }*/
    myChart.hideLoading();
    myChart.setOption({
        xAxis: [
            {
                data: ['长丰县', '庐江县', '庐阳区', '巢湖市', '包河区', '肥东县', '肥西县', '蜀山区', '瑶海区',]
            }
        ],
        series: [
            {
                // name:'总企业数',
                // type:'bar',
                data: [50, 10, 30, 150, 45, 176, 35, 62, 132]
            },
            {
                // name:'覆盖率',
                // type:'line',
                // yAxisIndex: 1,
                data: [52.00, 100, 63.33, 80.00, 60.00, 43.75, 48.57, 29.03, 35.60]
            }
        ]
    });
    /*    }
     },
     error : function(errorMsg) {
     alert("请求数据失败");
     }*/
}
}