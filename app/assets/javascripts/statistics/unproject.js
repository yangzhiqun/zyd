$(function(){
	main()
})
window.data={};
data.json1=	[
	  {'item':'酸价（KOH）','value':10},{'item':'过氧化值','value':15}
	];
data.json1=[
	  {'item':'酸价（KOH）','value':13},{'item':'过氧化值','value':11}
	];
function main(){
	// console.log(data.json1)
	$('#btn_area').click(function(event) {
		$('td').slideDown(500);
	});

	// 点击检验值弹出对应区域的数据详情
	$('.value_btn').each(function(){
		var that=$(this);
		that.click(function(event) {
			 var iTop = (window.screen.availHeight-400) / 2;
             var iLeft = (window.screen.availWidth-800) / 2;
			 window.open('./detailList.html', '_blank', 'height=400, width=800, top='+iTop+', left='+iLeft+', toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no')
		});
	});
}