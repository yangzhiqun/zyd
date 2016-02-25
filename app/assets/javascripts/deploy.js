/**
 * Created by ganggang on 16/2/25.
 */
$(function () {
    // 新建采样任务默认留空情况下点确认报错
    // 总局下达中央转移地方的任务，分配给各省
    $('#create_prov_plan').click(function () {
        if ($('#baosong_a').val() == '' || $('#baosong_a').val() == '请选择') {
            alert("请选择报送分类A");
            return false;
        }

        if ($('#baosong_b').val() == '' || $('#baosong_b').val() == '请选择') {
            alert("请选择报送分类B");
            return false;
        }

        if (confirm('确定部署该任务吗？')) {
            $.post('/tasks/create_prov_plan.json', {
                    quota: $('#quota').val(),
                    prov: $('#prov').val(),
                    dl: $('#dl').val(),
                    yl: $('#yl').val(),
                    cyl: $('#cyl').val(),
                    xl: $('#xl').val(),
                    identifier: $('#baosong_b').find('option:selected').attr('data-identifier')
                },
                function (data) {
                    if (data.status == 'OK') {
                        location.reload();
                    } else {
                        alert(data.msg);
                    }
                }, 'json');
        }
    });

    // 总局下达局本级任务, 直接下达给【抽检机构】
    $('#create_direct_plan').click(function () {

        if ($('#baosong_a').val() == '' || $('#baosong_a').val() == "请选择") {
            alert("请选择报送分类A");
            return false;
        }

        if ($('#baosong_b').val() == '' || $('#baosong_b').val() == '请选择') {
            alert("请选择报送分类B");
            return false;
        }

        if (confirm('确定部署该任务吗？')) {
            $.post('/tasks/create_direct_plan.json', {
                    quota: $('#quota').val(),
                    jg_id: $('#cyjg').val(),
                    test_jg_id: $('#jyjg').val(),
                    dl: $('#dl').val(),
                    yl: $('#yl').val(),
                    cyl: $('#cyl').val(),
                    xl: $('#xl').val(),
                    identifier: $('#baosong_b').find('option:selected').attr('data-identifier')
                },
                function (data) {
                    if (data.status == 'OK') {
                        location.reload();
                    } else {
                        alert(data.msg);
                    }
                }, 'json');
        }
    });

    // 报送分类A CHANGE事件
    $('#baosong_a').change(function () {
        var o = $(this);
        if (o.val() != '') {
            $.get('/baosong_bs/by_name.json', {a_name: o.val()}, function (data) {
                if (data.status == 'OK') {
                    $('#dl, #yl, #cyl, #xl').empty();

                    $('#baosong_b').empty();
                    $("<option>").text("请选择").appendTo($('#baosong_b'));
                    $.each(data.data, function () {
                        $("<option>").attr('data-identifier', this.identifier).attr("value", this.name).text(this.name).appendTo($('#baosong_b'));
                    });
                }
            }, "json")
        } else {
            $('#dl, #yl, #cyl, #xl, #baosong_b').empty();
        }
    });

    // 报送分类第二列
    $('#baosong_b').change(function () {
        $.get('/a_categories_by_identifier.json', {identifier: $(this).find('option:selected').attr('data-identifier')}, function (data) {
            location.href = "?tab=" + window.current_tab + "&baosong_a=" + $("#baosong_a").val() + "&baosong_b=" + $('#baosong_b').val();
        }, 'json');
    });

    // 大类
    $('#dl').change(function () {
        $.get('/b_categories_by_a_id.json', {a_category_id: $(this).find('option:selected').attr('data-id')}, function (data) {
            if (data.status == 'OK') {
                $('#yl, #cyl, #xl').empty();

                $('<option>').text("请选择").appendTo($('#yl'));
                $.each(data.data, function () {
                    $('<option>').attr('value', this.id).text(this.name).attr('data-id', this.id).appendTo($('#yl'));
                });
            }
        }, 'json');
    });

    // 亚类
    $('#yl').change(function () {
        $.get('/c_categories_by_b_id.json', {b_category_id: $(this).find('option:selected').attr('data-id')}, function (data) {
            if (data.status == 'OK') {
                $('#cyl, #xl').empty();

                $('#cyl').empty();
                $('<option>').text("请选择").appendTo($('#cyl'));
                $.each(data.data, function () {
                    $('<option>').attr('value', this.id).text(this.name).attr('data-id', this.id).appendTo($('#cyl'));
                });
            }
        }, 'json');
    });

    // 次亚类
    $('#cyl').change(function () {
        $.get('/d_categories_by_c_id.json', {c_category_id: $(this).find('option:selected').attr('data-id')}, function (data) {
            if (data.status == 'OK') {
                $('#xl').empty();

                $('<option>').text("请选择").appendTo($('#xl'));
                $.each(data.data, function () {
                    $('<option>').attr('value', this.id).text(this.name).attr('data-id', this.id).appendTo($('#xl'));
                });
            }
        }, 'json');
    });
    $('#jyjg').select2();
    $('#cyjg').select2().change(function () {
        var o = $(this).find('option:selected');
        if (parseInt(o.attr('data-jg-type')) == 3) {
            $('#jyjg').val(o.attr('value')).trigger('change');
        }
    });
    $('.task-deploy').bootstrapTable({
        onPostBody: function () {
            $('.task-deploy td:empty').remove();
        }
    });
});
