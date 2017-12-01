$(function(){
	chart();
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

// 图表展示
function chart(){   
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
            data:['总企业数','被检企业数','覆盖率']
        },
        xAxis: [
            {
                type: 'category',
                data: ['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '企业数',
                min: 0,
                max: 250,
                interval: 50,
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {
                type: 'value',
                name: '覆盖率',
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
                name:'总企业数',
                type:'bar',
                data:[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140]
            },
            {
                name:'被检企业数',
                type:'bar',
                data:[126, 50, 90, 204, 207, 77, 76, 82, 47, 88, 60, 123,60]
            },
            {
                name:'覆盖率',
                type:'line',
                yAxisIndex: 1,
                data:[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]
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
            data:['总企业数','被检企业数','覆盖率']
        },
        xAxis: [
            {
                type: 'category',
                data: ['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '企业数',
                min: 0,
                max: 250,
                interval: 50,
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {
                type: 'value',
                name: '覆盖率',
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
                name:'总企业数',
                type:'bar',
                data:[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140]
            },
            {
                name:'被检企业数',
                type:'bar',
                data:[126, 50, 90, 204, 207, 77, 76, 82, 47, 88, 60, 123,60]
            },
            {
                name:'覆盖率',
                type:'line',
                yAxisIndex: 1,
                data:[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]
            }
        ]
    };
    var myChart2=echarts.init(document.getElementById('chart_2'));
    myChart2.setOption(option2);
        //各市数据
    var anhui={
        xAxis:[{
            data:['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市']
        }],
        series:[
        {
            data:[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140]
        },
        {
            data:[126, 50, 90, 204, 207, 77, 76, 82, 47, 88, 60, 123,60]
        },
        {
            data:[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]
        }
        ]
    }
    var hefei= {
            xAxis: [
              {
                data: ['长丰县','庐江县','庐阳区','巢湖市','包河区','肥东县','肥西县','蜀山区','瑶海区',]
               }
             ],
            series: [
              {
                  // name:'总企业数',
                  // type:'bar',
                  data:[50, 10, 30, 150, 45, 176, 35, 62, 132]
              },
              {
                  // name:'被检企业数',
                  // type:'bar',
                  data:[26, 10, 19, 120, 27, 77, 17, 18, 47]
              },
              {
                  // name:'覆盖率',
                  // type:'line',
                  // yAxisIndex: 1,
                  data:[52.00, 100, 63.33, 80.00, 60.00, 43.75, 48.57, 29.03, 35.60]
              }
           ]
        }
    var wuhu={
        xAxis:[{
            data:['无为县','鸠江区','镜湖区','弋江区','三山区','芜湖县','繁昌县','南陵县']
        }],
        series:[
        {
            data:[144,145,198,156,90,134,134,198]
        },
        {
            data:[76,76,87,92,56,93, 34,91]
        },
        {
            data:[52.78,52.41,43.94,58.97,62.22,69.40,25.37,45.96]
        }
        ]
    }
    var bengbu={
        xAxis:[{
            data:['固镇县','五河县','怀远县','淮上区','龙子湖区','蚌山区','禹会区',]
        }],
        series:[
        {
            data:[98,123,187,156,198,155,167]
        },
        {
            data:[34,65,178,156,122,99,143]
        },
        {
            data:[34.69,52.85,95.19,100,61.61,63.87,85.63]
        }
        ]
    }
    //点击不同的市显示该市下级市县区相应的数据
    myChart1.on('click',function(params){
        // console.log(params.componentType);
        // 获取当前点击的市
        switch(params.name){
            case '安徽省':
            cityClick(myChart1,anhui);
            cityClick(myChart2,anhui);
            break;
            case '合肥':
            cityClick(this,hefei);
            break;
            case '芜湖':
            cityClick(this,wuhu);
            break;
            case '蚌埠':
            cityClick(this,bengbu);
            break;
            default:
            cityClick(myChart1,anhui);
            break;
        }
        
    });
    //根据下拉框的下拉选中项显示相应地区的数据
    
    $(document).on('change','#cqtj_option',function(){
        var optVal=$(this).val();
        switch(optVal){
            case '安徽省':
            cityClick(myChart1,anhui);
            cityClick(myChart2,anhui);
            break;
            case '合肥':
            cityClick(myChart1,hefei);
            cityClick(myChart2,hefei);
            break;
            case '芜湖':
            cityClick(myChart1,wuhu);
            cityClick(myChart2,wuhu);
            break;
            case '蚌埠':
            cityClick(myChart1,bengbu);
            cityClick(myChart2,bengbu);
            break;
            default:
            break;
        }
    });

    myChart2.on('click',function (params) {
        switch(params.name){
            case '合肥':
            cityClick(this,hefei);
            break;
            case '芜湖':
            cityClick(this,wuhu);
            break;
            case '蚌埠':
            cityClick(this,bengbu);
            break;
            default:
            cityClick(myChart2,anhui);            
            break;
        }        
    })
    //封装点击不同的市显示当前市下级数据
    function cityClick(myChart,data){
      myChart.setOption(data);  
    }

}    
