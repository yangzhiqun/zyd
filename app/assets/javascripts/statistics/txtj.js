$(function(){
    chart(datainfo1);
    myChart1=echarts.init(document.getElementById('chart_1'));
    myChart1.setOption(option1);
    // myChart2=echarts.init(document.getElementById('chart_2'));
    // myChart2.setOption(option2);

    //点击不同的市显示该市下级市县区相应的数据
    myChart1.on('click',function(params){
        // console.log(params.componentType);
        // 获取当前点击的市
        getChartInfo(this,params.name,2);

    });


    // myChart2.on('click',function (params) {
    //     getChartInfo(this,params.name,3);
    // });
    //封装点击不同的市显示当前市下级数据
    //function cityClick(myChart,data){
    //    myChart.setOption(data);
    //}
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
var myChart1;
// var myChart2;
var option1;
// var option2;
function chart(data){
    // Security Trends
     option1 = {
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
                itemStyle: {
                    normal: {
                        // 随机显示
                        color:function(d){
                            return "#"+Math.floor(Math.random()*(256*256*256-1)).toString(16);
                        },
                        label: {
                            show: true
                            // position: 'top',
                            // formatter: '{b}\n{c}'
                        }
                    }
                },
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



     /*option2 = {
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
                itemStyle: {
                    normal: {
                        // 随机显示
                        color:function(d){
                            return "#"+Math.floor(Math.random()*(256*256*256-1)).toString(16);
                        },
                        label: {
                            show: true
                            // position: 'top',
                            // formatter: '{b}\n{c}'
                        }
                    }
                },
                data:data.cjjg.y1
            },
            {
                name:'完全提交退修率',
                type:'line',
                yAxisIndex: 1,
                data:data.cjjg.y2
            }
        ]
    };*/
   // var myChart2=echarts.init(document.getElementById('chart_2'));
   // myChart2.setOption(option2);

    //根据相应地区的数据

   /* $(document).on('change','#cqtj_option',function(){
        var optVal=$(this).val();
        getChartInfo(myChart1,optVal,"1");
        getChartInfo(myChart2,optVal,"1");
        });
*/

}
//数据请求后台
function getChartInfo(myChart,params,flag){
    var time = $("#time").val();
    if(time==""){
        alert("请选择时间");
        return
    }
    myChart.showLoading();
      $.ajax({
     type : "post",
     contentType: "application/json",
     //async : true, //异步执行
     url : "AcceptData",
     dataType : "json", //返回数据形式为json
          data:{
              "time":time,
              "area":params,
              "flag": flag //0为表格  1，为图表
          },
     success : function(json) {
     if (json) {
    myChart.hideLoading();
    myChart.setOption({
        xAxis: [
            {
                data: json.x
            }
        ],
        series: [
            {
                // name:'总企业数',
                // type:'bar',
                data: json.y1
            },
            {
                // name:'覆盖率',
                // type:'line',
                // yAxisIndex: 1,
                data: json.y2
            }
        ]
    });
        }
     },
     error : function(errorMsg) {
     alert("请求数据失败");
     }
})

}