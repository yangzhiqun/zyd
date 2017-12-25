var timeFn = null;
//var info1 = {"x":['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','六安市'],
//"zqys":[200, 140, 170, 230, 245, 176, 135, 162, 132, 120, 160, 130,140],"bjqys":[126, 50, 90, 204, 207, 77, 76, 82, 47, 88, 60, 123,60],
//"fgl":[63.00, 35.71, 52.94, 88.70, 84.50, 43.75, 56.30, 50.61, 35.60, 73.33, 37.5, 94.62,42.86]};
// 图表展示
function chart(data){
    //生产企业覆盖率
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
                data:data.zqys
            },
            {
                name:'被检企业数',
                type:'bar',
                data:data.bjqys
            },
            {
                name:'覆盖率',
                type:'line',
                yAxisIndex: 1,
                data:data.fgl
            }
        ]
    };
    var myChart2=echarts.init(document.getElementById('chart_2'));
    myChart2.setOption(option2);



    //根据下拉框的下拉选中项显示相应地区的数据
    
    $(document).on('change','#cqtj_option',function(){
        var optVal=$(this).val();
        if($(".exportR").hasClass("hide")) {
            getChartInfo(myChart2, optVal, '1');//请求后台数据
        }else{
            getInfo(optVal, '0');
        }
    });

    //点击查询
    $('#checkBtn').click(function(event) {
        var getSelectInfo = $("#cqtj_option").val();
        if($(".exportR").hasClass("hide")){
            getChartInfo(myChart2,getSelectInfo,"1");
//                    getChartInfo(myChart2,getSelectInfo,"1");
        }else {
            getInfo(getSelectInfo,'0');//
        }
    });

//点击不同的市显示该市下级市县区相应的数据
    myChart2.on('click',function (params) {
        clearTimeout(timeFn);
        //由于单击事件和双击事件冲突，故单击的响应事件延迟250毫秒执行
        timeFn = setTimeout(getChartInfo(myChart2,params.name,'1'),250);//请求后台数据
    });

    myChart2.on('dblclick',function (params) {
        clearTimeout(timeFn);
       // alert(123);
        getChartInfo(myChart2,'','1');//请求后台数据
    })


}
//数据请求后台
function getChartInfo(myChart,params,flag){
    var data = {"x":['长丰县','庐江县','庐阳区','巢湖市','包河区','肥东县','肥西县','蜀山区','瑶海区'],
    "zqys":[50, 10, 30, 150, 45, 176, 35, 62, 132],
        "bjqys":[26, 10, 19, 120, 27, 77, 17, 18, 47],
        "fgl":[52.00, 100, 63.33, 80.00, 60.00, 43.75, 48.57, 29.03, 35.60]};
    myChart.showLoading();
  /*  $.ajax({
        type : "get",
        contentType: "application/json",
        async : false, //同步执行
        url : "",
        dataType : "json", //返回数据形式为json
        data:{
            "area":params,
            "flag": flag //0为表格  1，为图表
        },
        success : function(json) {
            if (json) { */
                myChart.hideLoading();
                myChart.setOption({
                    xAxis: [
                        {
                            data: data.x
                        }
                    ],
                    series: [
                        {
                            // name:'总企业数',
                            // type:'bar',
                            data:data.zqys
                        },
                        {
                            // name:'被检企业数',
                            // type:'bar',
                            data:data.bjqys
                        },
                        {
                            // name:'覆盖率',
                            // type:'line',
                            // yAxisIndex: 1,
                            data:data.fgl
                        }
                    ]
                });
       /*     }
        },
        error : function(errorMsg) {
            alert("请求数据失败");
        }
    })*/

}
