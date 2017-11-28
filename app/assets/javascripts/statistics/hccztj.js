$(function(){
  chart();
  changeBtn();
})
// 图表展示
function chart(){   
    // Security Trends
    var dataMap = {};
    function dataFormatter(obj) {
        var pList = ['人民食堂','食品网','食品企业','大众超市'];
        var temp;
        for (var mounth = 8; mounth <= 11; mounth++) {
            var max = 0;
            var sum = 0;
            temp = obj[mounth];
            for (var i = 0, l = temp.length; i < l; i++) {
                max = Math.max(max, temp[i]);
                sum += temp[i];
                obj[mounth][i] = {
                    name : pList[i],
                    value : temp[i]
                }
            }
            obj[mounth + 'max'] = Math.floor(max / 100) * 100;
            obj[mounth + 'sum'] = sum;
        }
        return obj;
    }
    
    dataMap.dataBHege = dataFormatter({
        //max : 60000,
        8:[500,42,20,15],
        9:[48,34,40,40],
        10:[39,42,45,49],
        11:[34,46,47,49]
    });
    
    dataMap.dataFujian = dataFormatter({
        //max : 4000,
        8:[100,120,145,189],
        9:[120,132,165,122],
        10:[98,80,67,50],
        11:[110,99,65,86]
    });
    
    dataMap.dataFujianbhg = dataFormatter({
        //max : 26600,
        8:[40,78,56,43],
        9:[33,48,10,52],
        10:[28,39,89,39],
        11:[26,37,87,42]
    });    
    dataMap.dataLian = dataFormatter({
        //max : 25000,
        8:[123,52,84,39],
        9:[106,42,71,34],
        10:[91,34,60,28],
        11:[83,28,52,26]
    });
    
    dataMap.dataYiyi = dataFormatter({
        //max : 3600,
        8:[17,41,91,22],
        9:[10,37,69,19],
        10:[10,33,6,17],
        11:[84,22,51,16]
    });
    
    dataMap.dataBuhege = dataFormatter({
        //max : 3200,
        8:[221,75,74,51],
        9:[186,57,61,44],
        10:[163,42,57,39],
        11:[159,31,44,28]
    });
    
    
    var option = {
        baseOption: {
            timeline: {
                // y: 0,
                axisType: 'category',
                // realtime: false,
                // loop: false,
                autoPlay: true,
                // currentIndex: 2,
                playInterval: 1000,
                // controlStyle: {
                //     position: 'left'
                // },
                data: [
                    '2017年8月','2017年9月','2017年10月','2017年11月'
                    // {
                    //     value: '11',
                    //     tooltip: {
                    //         formatter: '{b} GDP达到一个高度'
                    //     },
                    //     symbol: 'diamond',
                    //     symbolSize: 16
                    // }
                ]
            },
            tooltip: {
            },
            legend: {
                x: 'right',
                data: ['不合格处置数', '不合格处置完成数', '异议数', '复检数', '复检不合格数', '立案数'],
                // selected: {
                //     'GDP': false, '金融': false, '房地产': false
                // }
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
                    'data':[
                        '人民食堂','食品网','食品企业','大众超市'
                    ],
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
        options: [
            {
                title: {text: '2017年8月核查处置统计'},
                series: [
                    {data: dataMap.dataBHege['8']},
                    {data: dataMap.dataBuhege['8']},
                    {data: dataMap.dataYiyi['8']},
                    {data: dataMap.dataFujian['8']},
                    {data: dataMap.dataFujianbhg['8']},
                    {data: dataMap.dataLian['8']},
                    {data: [
                        {name: '不合格处置数', value: dataMap.dataBHege['8sum']},
                        {name: '不合格处置完成数', value: dataMap.dataBuhege['8sum']}
                    ]}
                ]
            },
            {
                title : {text: '2017年9月核查处置统计'},
                series : [
                    {data: dataMap.dataBHege['9']},
                    {data: dataMap.dataBuhege['9']},
                    {data: dataMap.dataYiyi['9']},
                    {data: dataMap.dataFujian['9']},
                    {data: dataMap.dataFujianbhg['9']},
                    {data: dataMap.dataLian['9']},
                    {data: [
                        {name: '不合格处置数', value: dataMap.dataBHege['9sum']},
                        {name: '不合格处置完成数', value: dataMap.dataBuhege['9sum']}
                    ]}
                ]
            },
            {
                title : {text: '2017年10月核查处置统计'},
                series : [
                    {data: dataMap.dataBHege['10']},
                    {data: dataMap.dataBuhege['10']},
                    {data: dataMap.dataYiyi['10']},
                    {data: dataMap.dataFujian['10']},
                    {data: dataMap.dataFujianbhg['10']},
                    {data: dataMap.dataLian['10']},
                    {data: [
                        {name: '不合格处置数', value: dataMap.dataBHege['10sum']},
                        {name: '不合格处置完成数', value: dataMap.dataBuhege['10sum']}
                    ]}
                ]
            },
            {
                title : {text: '2017年11月核查处置统计'},
                series : [
                    {data: dataMap.dataBHege['11']},
                    {data: dataMap.dataBuhege['11']},
                    {data: dataMap.dataYiyi['11']},
                    {data: dataMap.dataFujian['11']},
                    {data: dataMap.dataFujianbhg['11']},
                    {data: dataMap.dataLian['11']},
                    {data: [
                        {name: '不合格处置数', value: dataMap.dataBHege['11sum']},
                        {name: '不合格处置完成数', value: dataMap.dataBuhege['11sum']}
                    ]}
                ]
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
