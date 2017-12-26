//$(function(){
//    getDataTp(info);
//})

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
        search: true, //显示搜索框
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
                    var info = "<a target='_blank' href='/sp_bsbs/"+row.id+"/edit' >"+name+"</a>";
                    return info;
                }
            }
        ]
    });
}
