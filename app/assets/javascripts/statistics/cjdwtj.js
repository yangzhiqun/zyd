/*$(function(){

})*/
var datainfo = {"cgtj":{"x":['合肥承检1','合肥承检2','合肥承检3','合肥承检4','合肥承检5','合肥承检6'],
"jys":[600, 400, 700, 600, 800, 700],"hgs":[180, 600, 400, 700,600, 700],"bhgs":[100, 100, 200, 140, 160, 120],
"yczs":[80, 70, 140, 90, 160, 120],"czzs":[40, 30, 60, 70, 80, 60]},
"cjrw":{"x":['抽检监测（市级本级）','抽检监测（省级专项）','抽检监测（省级转移）'],"y":[12,23,7]}};
// 图表展示
function chart(data){
    // Security Trends
    var option1 = {
        color: ['#294650','#44A0A2','#E77B5A','#7EC9A9','#659E7D'],
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            }
        },
         legend: {
             data:['接样数','合格数','不合格数','已处置数','处置中数']
         },
        grid: {
            left: '3%',
            right: '4%',
            // bottom: '12%',
            containLabel: true
        },
        xAxis : [
            {
                type : 'category',
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
                data : data.cgtj.x,
                axisTick: {
                    alignWithLabel: true
                },
                axisLine:{
                    lineStyle:{
                        color:'#000'
                    }
                }
            }
        ],
        yAxis : [
            {type:'value'}                   
        ],
        series : [

            {
                name:'接样数',
                type:'bar',
                barWidth: '10%',
                data:data.cgtj.jys
            },
            {
                name:'合格数',
                type:'bar',
                barWidth: '10%',
                data:data.cgtj.hgs
            },
            {
                name:'不合格数',
                type:'bar',
                barWidth: '10%',
                data:data.cgtj.bhgs
            },
            {
                name:'已处置数',
                type:'bar',
                barWidth: '10%',
                data:data.cgtj.yczs
            },
            {
                name:'处置中数',
                type:'bar',
                barWidth: '10%',
                data:data.cgtj.czzs
            }
        ]
    };
    var myChart1=echarts.init(document.getElementById('chart_1'));
    myChart1.setOption(option1);

    var option2 = {
        color: ['#44A0A2'],
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            }
        },
        legend: {
            data:['承检机构数']
        },
        grid: {
            left: '3%',
            right: '4%',
            // bottom: '12%',
            containLabel: true
        },
        xAxis : [
            {
                type : 'category',
                axisLabel: {
                    interval: 0,
                    formatter: function(value){
                        //debugger
                        var ret = "";//拼接加\n返回的类目项
                        var maxLength = 2;//每项显示文字个数
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
                data : data.ccjrw.x,
                axisTick: {
                    alignWithLabel: true
                },
                axisLine:{
                    lineStyle:{
                        color:'#000'
                    }
                }
            }
        ],
        yAxis : [
            {type:'value'}
        ],
        series : [
            {
                name:'承检机构数',
                type:'bar',
                barWidth: '10%',
                data:data.ccjrw.y
            }
        ]
    };
    var myChart2=echarts.init(document.getElementById('chart_2'));
    myChart2.setOption(option2);
    //根据相应地区的数据
    // $(document).on('change','#cqtj_option',function(){
    //     var optVal=$(this).val();
    //     alert(optVal);
    //    // getChartInfo(myChart1,optVal);
    //    // getChartInfo(myChart2,optVal);
    // });
    //数据请求后台
    /*   function getChartInfo(myChart,params){
        myChart.showLoading();
          $.ajax({
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
         }
        myChart.hideLoading();
        //两个图标不同，这里需要判断
        myChart.setOption({
            xAxis: [
                {
                    data : ['合肥承检1','合肥承检2','合肥承检3','合肥承检4','合肥承检5','合肥承检6']
                }
            ],
            series : [

                {
                    name:'接样数',
                    type:'bar',
                    barWidth: '10%',
                    data:[600, 400, 700, 600, 800, 700]
                },
                {
                    name:'合格数',
                    type:'bar',
                    barWidth: '10%',
                    data:[180, 600, 400, 700,600, 700]
                },
                {
                    name:'不合格数',
                    type:'bar',
                    barWidth: '10%',
                    data:[100, 100, 200, 140, 160, 120]
                },
                {
                    name:'已处置',
                    type:'bar',
                    barWidth: '10%',
                    data:[80, 70, 140, 90, 160, 120]
                },
                {
                    name:'处置中',
                    type:'bar',
                    barWidth: '10%',
                    data:[40, 30, 60, 70, 80, 60]
                }
            ]
        });
            }
         },
         error : function(errorMsg) {
         alert("请求数据失败");
         }
    }*/
}
// 点击切换图表
function changeBtn(){
	$('#changeBtn').click(function(event) {
		var that=$(this);
		$('#table_testCompany').toggleClass('hide');
		$('.charts').toggleClass('hide');
		if($('#table_testCompany').is(':hidden')){
		    $("#defs").val('1');
			that.text('切换表格模式');
            $('.exportR').addClass('hide');
            $('.topbtnSect_cqtj').removeClass('hide');
		}else{
            $("#defs").val('0');
			that.text('切换图表模式');
			$('.exportR').removeClass('hide');
            $('.topbtnSect_cqtj').addClass('hide');
		}
	});
}
