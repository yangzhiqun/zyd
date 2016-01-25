// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
// 基础
//= require jquery
//= require bootstrap.min

//= require FusionCharts


// require bootstrap-editable

// jQuery插件
//= require jquery-migrate-1.2.1
//= require jquery.province
//= require jquery.PrintArea
//= require jquery.noty.packaged.min
//= require jquery.form.min
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/datepicker-zh-CN
//= require jquery-fileupload/basic
//= require jquery.fixedheadertable
//= require jquery.iframe-auto-height
//= require jquery.mousewheel
//= require jquery.tablednd
//= require jquery.dragtable
//= require jquery.storageapi

//= require bootstrap-table-all
//= require bootstrap-table-zh-CN
//= require bootstrap-editable

// AngularJs
//= require angular
//= require xeditable
//= require angularjs/select
//= require angular-sanitize
//= require angularjs/app
//= require angularjs/controller
//= require angular-ui-bootstrap-tpls

// Underscore
//= require underscore

//= require sp_bsb_publications

//= require provincesdata
//= require spfldata
// require spdata1
// require spdata2
// require spdata3
// require spdata4
// require spdata5
// require spdata6
// require spdata7
// require spdata8
// require spdata10
// require bjpdata
// require hzpdata
//= require select2
//= require react
//= require react_ujs
//= require components

$(function(){
  $('#preview').iframeAutoHeight({debug: false});
  
  $( ".datepicker" ).datepicker({dateFormat:"yy-mm-dd",
    changeMonth: true,
    changeYear: true
  });

  $('[data-toggle="tooltip"]').tooltip();
});
