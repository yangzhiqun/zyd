$(function(){
  $.ajaxSetup({  
    async : false  
  });    
  var prov_data = $('body').data('prov_data');
  if (!prov_data) {
    $.get('/new_prov_data.json', {}, function (data) {
      if (data.status == 'OK') {
        $('body').data('prov_data', data.prov_data);
        prov_data = $('body').data('prov_data');
      } else {
        $('body').data('prov_data', null);
      }
    }, 'json');
  }
  //$.each(prov_data.lvl2[15], function (i, prov) {
  //  $("#cqtj_option").append($('<option>').attr({'value': prov[0]}).text(prov[0]));
  //});
  $.each(prov_data, function (i, prov) {
    $("#cqtj_option").append('<tr><td class="cjdw_td">' +prov + '</td></tr>');
  });
})
