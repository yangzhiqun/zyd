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
            data:['抽样机构完全提交退修数','抽样机构完全提交退修率','检验机构完全提交退修数','检验机构完全提交退修率']
        },
        xAxis: [
            {
                type: 'category',
                axisLabel: {
                    interval: 0,
                    formatter: function(value){
                        //debugger
                        var ret = "";//拼接加\n返回的类目项
                        var maxLength = 1;//每项显示文字个数
                        var valLength = value.length;//X轴类目项的文字个数
                        var rowN = Math.ceil(valLength / maxLength); //类目项需要换行的行数
                        if (rowN > 1)//如果类目项的文字大于3,
                        {
                            for (var i = 0; i < rowN; i++) {
                                var temp = "";//每次截取的字符串
                                var start = i * maxLength;//开始截取的位置
                                var end = start + maxLength;//结束截取的位置
                                //这里也可以加一个是否是最后一行的判断，但是不加也没有影响，那就不加吧
                                temp = value.substring(start, end) + "\n";
                                ret += temp; //凭借最终的字符串
                            }
                            return ret;
                        }
                        else {
                            return value;
                        }
                    }
                },
                data: data.x,
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '退修数',
                min: 0,
               // max: 250,
                interval: 50,
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {
                type: 'value',
                name: '退修率',
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
                name:'抽样机构完全提交退修数',
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
                data:data.y1
            },
            {
                name:'抽样机构完全提交退修率',
                type:'line',
                yAxisIndex: 1,
                data:data.y2
            },
            {
                name:'检验机构完全提交退修数',
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
                data:data.y1
            },
            {
                name:'检验机构完全提交退修率',
                type:'line',
                yAxisIndex: 1,
                data:data.y2
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
     type : "get",
     contentType: "application/json",
     //async : true, //异步执行
     url : "retirement_statistics",
     dataType : "json", //返回数据形式为json
          data:{
              "time":time.replace(/\ +/g,""),
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
            },
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
