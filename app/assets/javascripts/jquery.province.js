$.fn.ProvinceCity = function (settings) {    var _self = this;    _self.find("select").empty();    // 省份    var $sel1 = _self.find("select").eq(0);    // 市    var $sel2 = _self.find("select").eq(1);    // 县    var $sel3 = _self.find("select").eq(2);    // 默认省份在GP中的 index    var proindex = jQuery.inArray(settings.dprovince, GP);    // 设置了省份默认值    if (proindex != -1) {        // 取得市在GT中的index        var dcityindex = jQuery.inArray(settings.dcity, GT[proindex - 1]);        // 如果没有设置市的默认值，则默认为第一个option        if (dcityindex == -1) dcityindex = 0;        // 取得县在GC中的index        var lcityindex = jQuery.inArray(settings.lcity, GC[proindex - 1][dcityindex - 1]);        // 如果县么有默认值，则去第一个option        if (lcityindex == -1) lcityindex = 0;    } else {        dcityindex = 0;        lcityindex = 0;    }    if (_self.data("province")) {        $sel1.append("<option value='" + _self.data("province")[1] + "'>" + _self.data("province")[0] + "</option>");    }    // 遍历省份，将省份的select进行填充    $.each(GP, function (index, data) {        var val = data;        if (data == '请选择') {            val = '';        }        // 如果当前元素是设置的默认值，则让其选中，否则直接添加        if (index == proindex) {            $sel1.append("<option value='" + val + "' selected='selected'>" + data + "</option>");        } else {            $sel1.append("<option value='" + val + "'>" + data + "</option>");        }    });    if (_self.data("city1")) {        $sel2.append("<option value='" + _self.data("city1")[1] + "'>" + _self.data("city1")[0] + "</option>");    }    if (_self.data("city2")) {        $sel3.append("<option value='" + _self.data("city2")[1] + "'>" + _self.data("city2")[0] + "</option>");    }    var index1 = "";    // 省份select的事件绑定    $sel1.change(function () {        // 清空市、县select        $sel2[0].options.length = 0;        $sel3[0].options.length = 0;        // 取得当前选中的省份index        index1 = this.selectedIndex;        if (index1 == 0) {            if (_self.data("city1")) {                $sel2.append("<option value='" + _self.data("city1")[1] + "'>" + _self.data("city1")[0] + "</option>");            }            if (_self.data("city2")) {                $sel3.append("<option value='" + _self.data("city2")[1] + "'>" + _self.data("city2")[0] + "</option>");            }        } else {            // 遍历该省份下市并填充select2            $.each(GT[index1 - 1], function (index, data) {                var val = data;                if (data == '请选择') {                    val = '';                }                if (dcityindex == index) {                    $sel2.append("<option value='" + val + "' selected='selected'>" + data + "</option>");                } else {                    $sel2.append("<option value='" + val + "'>" + data + "</option>");                }            });            // 遍历县的列表            if(dcityindex > 0)            $.each(GC[index1 - 1][dcityindex - 1], function (index, data) {                var val = data;                if (data == '请选择') {                    val = '';                }                if (lcityindex == index) {                    $sel3.append("<option value='" + val + "' selected='selected'>" + data + "</option>");                } else {                    $sel3.append("<option value='" + val + "'>" + data + "</option>");                }            })        }    }).change();    // 市select的事件绑定    var index2 = "";    $sel2.change(function () {        // 清空县select        $sel3[0].options.length = 0;        index2 = this.selectedIndex;        $.each(GC[index1 - 1][index2], function (index, data) {            var val = data;            if (data == '请选择') {                val = '';            }            $sel3.append("<option value='" + val + "'>" + data + "</option>")        })    });    return _self;};