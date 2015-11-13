// Required JS
//
'use strict';
var app = angular.module('Sp', [ 'ui.select', 'ngSanitize', 'xeditable', 'ui.bootstrap']);

app.run(['editableOptions', function(editableOptions) {
  editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
}]);

