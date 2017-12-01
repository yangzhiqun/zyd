$(function(){
  chart();
  changeBtn();
})
// 图表展示
function chart(){   
    // Security Trends
    var option = {
        color: ['#DB2824','#294650','#44A0A2','#E77B5A','#7EC9A9','#659E7D'],
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
             data:['任务数','接样数','合格数','不合格数','已处置','处置中']
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
                data : ['合肥承检1','合肥承检2','合肥承检3','合肥承检4','合肥承检5','合肥承检6'],
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
                name:'任务数',
                type:'bar',
                barWidth: '10%',
                data:[1000, 1200, 1500, 1600, 1800, 1700],
                markLine : {
                lineStyle: {
                    normal: {
                        type: 'dashed'
                    }
                },
                data : [
                       [{type : 'min'}, {type : 'max'}]
                   ]
                }
            },
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
    };
    var myChart=echarts.init(document.getElementById('chart'))
    myChart.setOption(option);
}
// 点击切换图表
function changeBtn(){
	$('#changeBtn').click(function(event) {
		var that=$(this);
		$('#table_testCompany').toggleClass('hide');
		$('.charts_1').toggleClass('hide');
		if($('#table_testCompany').is(':hidden')){
			that.text('切换表格模式');
            $('.exportR').addClass('hide');
            $('.topbtnSect_cqtj').removeClass('hide');
		}else{
			that.text('切换图表模式');
			$('.exportR').removeClass('hide');
            $('.topbtnSect_cqtj').addClass('hide');
		}
	});
}
