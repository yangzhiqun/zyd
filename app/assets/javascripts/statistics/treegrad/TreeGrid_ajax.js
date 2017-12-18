/**
 * @author 陈举民
 * @version 1.0
 * @link http://chenjumin.javaeye.com
 */
TreeGrid = function (_config) {
    _config = _config || {};

    var s = "";
    var rownum = 0;
    var __root;
    var result = [];

    var __selectedData = null;
    var __selectedId = null;
    var __selectedIndex = null;
    var folderOpenIcon = (_config.folderOpenIcon || TreeGrid.FOLDER_OPEN_ICON);
    var folderCloseIcon = (_config.folderCloseIcon || TreeGrid.FOLDER_CLOSE_ICON);
    var defaultLeafIcon = (_config.defaultLeafIcon || TreeGrid.DEFAULT_LEAF_ICON);

    //显示表头行
    drowHeader = function () {
        s += "<tr class='header' height='" + (_config.headerHeight || "25") + "'>";
        var cols = _config.columns;
        for (i = 0; i < cols.length; i++) {
            var col = cols[i];
            s += "<td align='" + (col.headerAlign || _config.headerAlign || "center") + "' width='" + (col.width || "") + "'>" + (col.headerText || "") + "</td>";
        }
        s += "</tr>";
    }

    //递归显示数据行
    drowData = function () {
        var rows = _config.data;
        var cols = _config.columns;
        drowRowData(rows, cols, 1, "");
    }

    //局部变量i、j必须要用 var 来声明，否则，后续的数据无法正常显示
    drowRowData = function (_rows, _cols, _level, _pid) {
        var folderColumnIndex = (_config.folderColumnIndex || 0);
//debugger;
        for (var i = 0; i < _rows.length; i++) {
            var id = _pid + "_" + i; //行id
            var row = _rows[i];

            s += "<tr id='TR" + id + "' data-pid='" + ((_pid == "") ? "0" : ("TR" + _pid)) + "' data-open='N' data-row=\"" + TreeGrid.json2str(row) + "\" data-rowIndex='" + rownum++ + "'>";
            for (var j = 0; j < _cols.length; j++) {
                var col = _cols[j];
                s += "<td id='"+_level+"' align='" + (col.dataAlign || _config.dataAlign || "left") + "'";

                //层次缩进
                if (j == folderColumnIndex) {
                    s += " style='text-indent:" + (parseInt((_config.indentation || "20")) * (_level - 1)) + "px;'> ";
                } else {
                    s += ">";
                }

                //节点图标
                if (j == folderColumnIndex) {
                    //if (row.children) { //有下级数据
                    s += "<img id='img_"+id+"' data-folder='Y' data-trid='TR" + id + "' src='" + folderCloseIcon + "' class='image_hand'>";
                    // } else {
                    //     s += "<img src='" + defaultLeafIcon + "' class='image_nohand'>";
                    // }
                }

                //单元格内容
                if (col.handler) {
                    s += (eval(col.handler + ".call(new Object(), row, col)") || "") + "</td>";
                } else {
                    s += (row[col.dataField] || "") + "</td>";
                }
            }
            s += "</tr>";

            //递归显示下级数据
            //if (row.children) {
            //    drowRowData(row.children, _cols, _level + 1, id);
            //}
        }
    }

    //主函数
    this.show = function () {
        this.id = _config.id || ("TreeGrid" + TreeGrid.COUNT++);

        s += "<table id='" + this.id + "' cellspacing=0 cellpadding=0 width='" + (_config.width || "100%") + "' class='TreeGrid'>";
        drowHeader();
        drowData();
        s += "</table>";

        __root = jQuery("#" + _config.renderTo);
        __root.append(s);

        //初始化动作
        init();
        // expand("");
    }

    init = function () {
        //以新背景色标识鼠标所指行
        if ((_config.hoverRowBackground || "false") == "true") {
            __root.find("tr").hover(
                function () {
                    if (jQuery(this).attr("class") && jQuery(this).attr("class") == "header") return;
                    jQuery(this).addClass("row_hover");
                },
                function () {
                    jQuery(this).removeClass("row_hover");
                }
            );
        }

        //将单击事件绑定到tr标签
        __root.find("tr").die().live("click", function () {
            __root.find("tr").removeClass("row_active");
            jQuery(this).addClass("row_active");

            //获取当前行的数据
            __selectedData = jQuery(this).attr('data-row');
            __selectedId = jQuery(this).attr('id');
            __selectedIndex = jQuery(this).attr('data-rowIndex');

            //行记录单击后触发的事件
            if (_config.itemClick) {
                eval(_config.itemClick + "(__selectedId, __selectedIndex, TreeGrid.str2json(__selectedData))");
            }
        });

        //展开、关闭下级节点
        __root.find("img[data-folder='Y']").die().live("click", function () {

            var trid = jQuery(this).attr("data-trid");

            var isOpen = __root.find("#" + trid).attr("data-open");
            if(isOpen == "N"){
                result = [];
                resultInfo(trid);
                getInfoNext(trid);
            }
            isOpen = (isOpen == "Y") ? "N" : "Y";
            __root.find("#" + trid).attr("data-open", isOpen);
            showHiddenNode(trid, isOpen);
        });
    }
    /**
     * ajax请求后台数据
     */
    getInfoNext =function(trid){
        $.ajax({
          type : "get",
          async : false, //异步执行
          url : "/food_subset_statistics",
          dataType : "json", //返回数据形式为json
          data:{
            params: TreeGrid.json2strone(result),//上级名称
            time:$("#time").val(),
            baosongA:$("#checkbox_optionH").val()
          },
          success: function(data){
            if (data) {
              setChildren(data, _config.columns,$("#"+trid));
            }else{
              alert("数据请求失败");
              return;
            }
          },
          error:function(){
            alert("数据请求失败");
            return;
          }
        })
    }
    /***
     * 组合子节点
     * @param {Object} _rows
     * @param {Object} _cols
     * @param {Object} info
     */
    setChildren = function (_rows, _cols,info){
        //debugger;
        var _level = Number(info.find("td").attr("id"))+1;//获取子节点级别
        var _pid = info.attr("id");//获取父节点id
        __root.find("tr[data-pid='"+_pid+"']").remove(); //初始化清空原加载数据
        var folderColumnIndex = (_config.folderColumnIndex || 0);
//debugger;
        for (var i = 0; i < _rows.length; i++) {
            var id = _pid + "_" + i; //行id
            var row = _rows[i];
            var tr = "";
            tr += "<tr id='" + id + "' data-pid='" +_pid+ "' data-open='N' data-row=\"" + TreeGrid.json2str(row) + "\" data-rowIndex='" + rownum++ + "'>";
            for (var j = 0; j < _cols.length; j++) {
                var col = _cols[j];
                tr += "<td id='"+_level+"' align='" + (col.dataAlign || _config.dataAlign || "left") + "'";

                //层次缩进
                if (j == folderColumnIndex) {
                    tr += " style='text-indent:" + (parseInt((_config.indentation || "20")) * (_level - 1)) + "px;'> ";
                } else {
                    tr += ">";
                }

                //节点图标
                if (j == folderColumnIndex) {
                    // if (row.children) { //有下级数据
                    tr += "<img id='img_"+id+"' data-folder='Y' data-trid='" + id + "' src='" + folderCloseIcon + "' class='image_hand'>";
                    /* } else {
                     tr += "<img src='" + defaultLeafIcon + "' class='image_nohand'>";
                     }*/
                }

                //单元格内容
                if (col.handler) {
                    tr += (eval(col.handler + ".call(new Object(), row, col)") || "") + "</td>";
                } else {
                    tr += (row[col.dataField] || "") + "</td>";
                }
            }
            tr += "</tr>";
            info.after(tr);
            //递归显示下级数据
            /*if (row.children) {
             setChildren(row.children, _cols, _level + 1, id,info);
             }*/
            //setinit($("#TR"+id));

        }
    }
    //显示或隐藏子节点数据
    showHiddenNode = function (_trid, _open,info) {
        //debugger;
        if (_open == "N") { //隐藏子节点
            __root.find("#" + _trid).find("img[data-folder='Y']").attr("src", folderCloseIcon);
            __root.find("tr[id^=" + _trid + "_]").css("display", "none");
        } else { //显示子节点
            __root.find("#" + _trid).find("img[data-folder='Y']").attr("src", folderOpenIcon);
            showSubs(_trid);
        }
    }

    //递归检查下一级节点是否需要显示
    showSubs = function (_trid) {
        //debugger;
        var isOpen = __root.find("#" + _trid).attr("data-open");
        if (isOpen == "Y") {
            var trs = __root.find("tr[data-pid=" + _trid + "]");
            trs.css("display", "");

            for (var i = 0; i < trs.length; i++) {
                showSubs(trs[i].id);
            }
        }
    }

    //展开或收起所有节点
    this.expandAll = function (isOpen) {
        var trs = __root.find("tr[data-pid='0']");
        for (var i = 0; i < trs.length; i++) {
            var trid = trs[i].id || trs[i].getAttribute("id");
            showHiddenNode(trid, isOpen);
        }
    }

    resultInfo = function(info){

        //result = [];
        var local = TreeGrid.str2json(__root.find("#" + info).attr("data-row")).name;
        var p = __root.find("#" + info).attr("data-pid")
        result.push(local);
        if(p!=0){
            resultInfo(p);
        }

    }
    /* expand = function(info){
     var data1 = [{name:"清新分公司1",code: "CQ"},{name:"清新分公司2",code: "11111"}]
     if(info!=null && info!=""){
     //debugger;
     info = __root.find("tr[data-pid='"+info+"']");
     //console.log(__root.find("tr[data-pid='"+info+"']"));
     var events1 = info.find("img[data-folder='Y']").data("events");
     if(events1 && events1["click"]){
     return;
     }
     info.find("img[data-folder='Y']").click(function () {
     var trid = jQuery(this).attr("data-trid");
     var isOpen = __root.find("#" + trid).attr("data-open");
     if(isOpen == "N"){
     result = [];
     resultInfo(trid);
     setChildren(data1, _config.columns,$("#"+trid));
     }
     isOpen = (isOpen == "Y") ? "N" : "Y";
     __root.find("#" + trid).attr("data-open", isOpen);
     showHiddenNode(trid, isOpen,info);
     })
     }else{
     var events = __root.find("img[data-folder='Y']").data("events");
     if(events && events["click"]){
     return ;
     }
     __root.find("img[data-folder='Y']").click(function () {
     var trid = jQuery(this).attr("data-trid");

     var isOpen = __root.find("#" + trid).attr("data-open");
     if(isOpen == "N"){
     result = [];
     resultInfo(trid);
     setChildren(data1, _config.columns, $("#"+trid));
     }
     isOpen = (isOpen == "Y") ? "N" : "Y";
     __root.find("#" + trid).attr("data-open", isOpen);
     showHiddenNode(trid, isOpen,"");
     })
     }
     }*/
    //取得当前选中的行记录
    this.getSelectedItem = function () {
        return new TreeGridItem(__root, __selectedId, __selectedIndex, TreeGrid.str2json(__selectedData));
    }

};

//公共静态变量
TreeGrid.FOLDER_OPEN_ICON = "images/folderOpen.gif";
TreeGrid.FOLDER_CLOSE_ICON = "images/folderClose.gif";
TreeGrid.DEFAULT_LEAF_ICON = "images/defaultLeaf.gif";
TreeGrid.CORR = {0:"sp_s_70",1:"sp_s_67",2:"sp_s_17",3:"sp_s_18",4:"sp_s_19",5:"sp_s_20"}
TreeGrid.COUNT = 1;

//将json对象转换成字符串
TreeGrid.json2str = function(obj){
    var arr = [];

    var fmt = function(s){
        if(typeof s == 'object' && s != null){
            if(s.length){
                var _substr = "";
                for(var x=0;x<s.length;x++){
                    if(x>0) _substr += ", ";
                    _substr += TreeGrid.json2str(s[x]);
                }
                return "[" + _substr + "]";
            }else{
                return TreeGrid.json2str(s);
            }
        }
        return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
    }

    for(var i in obj){
        if(typeof obj[i] != 'object'){ //暂时不包括子数据
            arr.push(i + ":" + fmt(obj[i]));
        }
    }

    return '{' + arr.join(', ') + '}';
}

//将json对象转换成字符串
TreeGrid.json2strone = function(obj){
    obj = obj.reverse();
    var arr = [];

    var fmt = function(s){
        if(typeof s == 'object' && s != null){
            if(s.length){
                var _substr = "";
                for(var x=0;x<s.length;x++){
                    if(x>0) _substr += ", ";
                    _substr += TreeGrid.json2str(s[x]);
                }
                return "[" + _substr + "]";
            }else{
                return TreeGrid.json2str(s);
            }
        }
        return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
    }

    for(var i in obj){
        if(typeof obj[i] != 'object'){ //暂时不包括子数据
            arr.push("'"+TreeGrid.CORR[i]+"'" + "=>" + fmt(obj[i]));
        }
    }

    return '{' + arr.join(', ') + '}';
}

TreeGrid.str2json = function(s){
    var json = null;
    if(jQuery.browser.msie){
        json = eval("(" + s + ")");
    }else{
        json = new Function("return " + s)();
    }
    return json;
}

//数据行对象
function TreeGridItem (_root, _rowId, _rowIndex, _rowData){
    var __root = _root;

    this.id = _rowId;
    this.index = _rowIndex;
    this.data = _rowData;

    this.getParent = function(){
        var pid = jQuery("#" + this.id).attr("data-pid");
        if(pid!=""){
            var rowIndex = jQuery("#" + pid).attr("data-rowIndex");
            var data = jQuery("#" + pid).attr("data-row");
            return new TreeGridItem(_root, pid, rowIndex, TreeGrid.str2json(data));
        }
        return null;
    }

    this.getChildren = function(){
        var arr = [];
        var trs = jQuery(__root).find("tr[data-pid='" + this.id + "']");
        for(var i=0;i<trs.length;i++){
            var tr = trs[i];
            arr.push(new TreeGridItem(__root, tr.id, tr.rowIndex, TreeGrid.str2json(tr.data)));
        }
        return arr;
    }
};
