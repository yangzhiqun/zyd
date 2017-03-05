$.fn.CfdaProvince = function (config) {
    var self = this;
    if (!config) {
        config = {};
    }

    var level1 = $(self.find('select')[0]);
    var level2 = $(self.find('select')[1]);
    var level3 = $(self.find('select')[2]);
    var selected1 = 0;
    var selected2 = 0;
    var selected3 = 0;

    self.append(level1);
    self.append(level2);
    self.append(level3);

    $('<label>省:</label>').insertBefore(level1);
    $('<label>&emsp;市:</label>').insertBefore(level2);
    $('<label>&emsp;县:</label>').insertBefore(level3);

    var prov_data = $('body').data('prov_data');
    if (!prov_data) {
        $.get('/prov_data.json', {}, function (data) {
            if (data.status == 'OK') {
                $('body').data('prov_data', data.prov_data);
                prov_data = $('body').data('prov_data');
                render_selector();
            } else {
                $('body').data('prov_data', null);
            }
        }, 'json');
    } else {
        render_selector();
    }

    level1.change(function () {
        selected1 = this.selectedIndex - 1;
        selected2 = 0;
        selected3 = 0;
        level2.empty();
        level3.empty();
        level3.append($('<option>请选择</option>'));
        level2.append($('<option>请选择</option>'));
        $.each(prov_data.lvl2[selected1], function (i, prov) {
            level2.append($('<option>').attr({'value': prov[0]}).text(prov[0]));
        });

        if (config.level2) {
            // console.log(config)
            var info = config.level2;
            if(config.level2=="-请选择-"){
                info = "请选择"
            }
            level2.val(info);
            selected2 = level2[0].selectedIndex - 1;
        }
        if(level2.val()!=null && level2.val()!="请选择" && level2.val()!="-请选择-" && level2.val()!=""){
            level2.trigger('change');
        }
    });

    level2.change(function () {
        selected2 = this.selectedIndex - 1;
        selected3 = 0;
        level3.empty();
        level3.append($('<option>请选择</option>'));
        $.each(prov_data.lvl3[selected1][selected2], function (i, prov) {
            level3.append($('<option>').attr({'value': prov[0]}).text(prov[0]));
        });
        if (config.level3) {
            level3.val(config.level3);
            selected3 = level3[0].selectedIndex - 1;
        }
    });

    // Render Selector
    function render_selector() {
        level1.empty();
        level1.append($('<option>请选择</option>'));
        $.each(prov_data.lvl1, function (i, prov) {
            level1.append($('<option>').attr({'value': prov[0]}).text(prov[0]));
        });
        if (config.level1) level1.val(config.level1).trigger('change');
    }

    return self;
};

$.fn.CfdaProvince_1 = function (config) {
  var self = this;
  if (!config) {
      config = {};
  }
		 
  var level1 = $(self.find('select')[0]);

  self.append(level1);

  var prov_data = $('body').data('prov_data');
	var num       = 0
  if (!prov_data) {
      $.get('/prov_data.json', {}, function (data) {
          if (data.status == 'OK') {
              $('body').data('prov_data', data.prov_data);
              prov_data = $('body').data('prov_data');
							province_num(config["level1"]);
              render_selector(num);
          } else {
              $('body').data('prov_data', null);
          }
      }, 'json');
  } else {
      render_selector();
  }

	function province_num(province) {
		$.each(prov_data.lvl1, function (i, prov) {
			if (province == prov[0]) {
				num = i;
				return;
			}
		});
	}

  function render_selector(num) {
	  //level1.append($('<option>请选择</option>'));	
		$.each(prov_data.lvl2[num], function (i, prov) {
			level1.append($('<option>').attr({'value': prov[0]}).text(prov[0]));
		});
    if (config.level2) {
      level1.val(config.level2.replace(/-/g, ''));
    }
		if (level1.val() != '请选择') {
			level1.attr("disabled","disabled");				
		}
	}
  return self;
};
