$(function(){
    getDataTp(info);
})

var info = [{"id":"1","sf":"安徽","bcydws":"阜阳","rwly":"安庆市食品药品监督管理局",
"cybh":"121903","ypmc":"大豆油","cydwmc":"安庆市食品药品监督管理局","jyjgmc":"安庆市检验检测机构01","ypsfqr":"样品未确认","tbzt":"2"}];
//加载列表
function getDataTp(info){
    $('#tb_report1').bootstrapTable({
        //url: '/GroupColumns/GetReport',         //请求后台的URL（*）
        //method: 'get',                      //请求方式（*）
        data:info,
        // datatype:'json',
        toolbar: '#toolbar',                //工具按钮用哪个容器
        striped: true,                      //是否显示行间隔色
        cache: false,                      //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        //search: true, //显示搜索框
         pagination: true,                   //是否显示分页（*）
        // sortOrder: "asc",                   //排序方式
        //queryParams: oTableInit.queryParams,//传递参数（*）
         sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
         pageNumber: 1,                       //初始化加载第一页，默认第一页
         pageSize: 5,                       //每页的记录行数（*）
         pageList: [5, 10],      //可供选择的每页的行数（*）
        columns : [
            {
                title : '序号',//标题  可不加
                formatter : function(value,row, index) {
                    return index + 1;
                }
            },{
                field : 'sf',
                title : '省份',
                align : 'center'
                //sortable : true 排序
            },
            {
                field : 'bcydws',
                title : '被抽样单位市',
                align : 'center'
                //sortable : true 排序
            },
            {
                field : 'rwly',
                title : '任务来源',
                align : 'center'
            },{
                field : 'cybh',
                title : '抽样编号',
                align : 'center'
            },{
                field : 'ypmc',
                title : '样品名称',
                align : 'center'
            },{
                field : 'cydwmc',
                title : '采样单位名称',
                align : 'center'
            },{
                field : 'jyjgmc',
                title : '检验机构名称',
                align : 'center'
            },{
                field : 'ypsfqr',
                title : '样品是否确认',
                align : 'center'
            },{
                field : 'tbzt',
                title : '填报状态',
                align : 'center',
                formatter : function (value, row, index) {
                    var n = Number(value);
                    var name = "";
                    if(n<2){
                        name = "填报样品信息";
                    }else if(n < 3){
                        name = "填报检测数据";
                    }else if(n==3){
                        name = "退回待修数据";
                    }else if(n==4){
                        name = "待机构审核";
                    }else if(n==5){
                        name = "待机构批准";
                    }else if(n==16){
                        name = "报告发送人";
                    }
                    else if(n==9){
                        name = "完全提交";
                    }
                    else if(n==6){
                        name = "待省局审核";
                    }
                    else {
                        name = "填报样品信息";
                    }

                    var info = "<a href='/sp_bsbs/"+row.field.id+"/edit' >"+name+"</a>";
                    return info;
                }
            }
        ]
    });
}
/**
 *
 * @param url 后台url
 * @param params 参数
 * @param flag 类型 0，点击地图；1，点击抽样编号
 */
function getinfo(url,params,flag){


    /*  $.ajax({
     type : "post",
     async : true, //异步执行
     url : "AcceptData",
     dataType : "json", //返回数据形式为json
     success : function(json) {
         if(flag=='1'){
         //先销毁表格
         $('#tb_report2').bootstrapTable('destroy');
         $('#tb_report3').bootstrapTable('destroy');
             getData2(json);
             getData3(json);
         }else if(flag=='2'){
         $('#tb_report3').bootstrapTable('destroy');
             getData3(json);
         }
     },
     error:function(){
        alert('加载数据失败');
     }*/
}