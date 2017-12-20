
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
                field : 'xkzh',
                title : '生产许可证编号',
                align : 'center'
                //sortable : true 排序
            },
            {
                field : 'fzdw',
                title : '发证单位',
                align : 'center'
                //sortable : true 排序
            },
            {
                field : 'qymc',
                title : '企业名称',
                align : 'center'
            },{
                field : 'province',
                title : '所在省',
                align : 'center'
            },{
                field : 'city',
                title : '所在市',
                align : 'center'
            },{
                field : 'county',
                title : '所在县',
                align : 'center'
            },{
                field : 'id',
                title : '详情',
                align : 'center',
                formatter : function (value, row, index) {
                    var info = "<a target='_blank' href='/sp_production_infos/"+row.id+"/edit' >"+name+"</a>";
                    return info;
                }
            }
        ]
    });
}

