app.controller('NewestsPlanMakerCtrl', ['$scope', '$http', 'BaosongB', '$q', function ($scope, $http, BaosongB, $q) {
    $scope.baosong_b = BaosongB;
    $scope.is_editing_a = false;
    $scope.is_editing_b = false;
    $scope.is_editing_c = false;
    $scope.is_editing_d = false;

    // 当前选择的各个分类的ID
    $scope.selected = {a_category_id: null, b_category_id: null, c_category_id: null, d_category_id: null};
		$scope.selected_name = {a_category_name: null,b_category_name: null,c_category_name: null,d_category_name: null};
    $scope.select = function (category, obj, category_name) {
        $scope.selected[category] = obj.id;
        switch (category) {
            case 'a_category_id':
                delete $scope.selected['b_category_id'];
                delete $scope.selected['c_category_id'];
                delete $scope.selected['d_category_id'];
								$scope.selected_name.a_category_name = category_name;

                load_categories(category);

                break;
            case 'b_category_id':
                delete $scope.selected['c_category_id'];
                delete $scope.selected['d_category_id'];
								$scope.selected_name.b_category_name = category_name;

                load_categories(category);
								category = "BCategory"
								upadte_list(category,$scope.baosong_b.identifier,$scope.b_categories,$scope.selected_name);
                break;
            case 'c_category_id':
                delete $scope.selected['d_category_id'];
								$scope.selected_name.c_category_name = category_name;

                load_categories(category);

                break;
            case 'd_category_id':
								$scope.selected_name.d_category_name = category_name;
                load_check_items();
                break;
        }
			console.log($scope.selected_name);
    };

    $scope.toggleItem = function (item) {
        if ($scope.current_item == item) {
            delete $scope.current_item;
        } else {
            $scope.current_item = item;
        }
    };

    $scope.deleteItem = function (idx) {
        if (confirm("确定移除该检测项目吗？")) {
            $scope.check_items.splice(idx, 1);
        }
    };

    $scope.removeOption = function (options, idx) {
        if (confirm('确定移除吗？')) {
            options.splice(idx, 1);
        }
    };

    $scope.doSave = function (did) {
        if (confirm("我确定要发布所填信息，请帮我保存！")) {
            var params = {};
            params.items = pack_check_items($scope.check_items);
            $http.post("/d_categories/" + did + "/update_check_items.json", params).then(function (res) {
                if(res.data.status == 'OK') {
                    alert('保存成功！');
                }
            }, function () {
                alert('保存请求失败！');
            });
        }
    };

    $scope.doRemoveCategory = function (model_name, collection, category) {
        if (!confirm('确定删除所选项目吗？')) {
            return false;
        }

        var ids = [];
        angular.forEach(collection, function (c) {
            if (!!c.checked) {
                ids.push(c.id);
                c.enable = false;
            }
        });

        $http.post('/category_batch_delete/' + model_name + '.json', {ids: ids.join(',')}).then(function (res) {

        }, function () {
            alert('删除失败');
        });
    };

    $scope.addCheckItem = function () {
        var item = {options: [], PDYJ: []};
        $scope.check_items.push(item);
        $scope.current_item = item;
    };

    // 更新分类名称
    $scope.updateCategoryName = function (type_model, value, category) {
        if (category.name == value) {
            return null;
        }
        if (!confirm('确定要更改分类名称吗？')) {
            return '';
        }
        var defer = $q.defer();

        var params = {data: {name: value}, id: category.id};

        $http.post('/update_category/' + type_model + '.json', params).then(function (res) {
            defer.resolve(res.data.msg);
        }, function () {
            defer.resolve('请求失败');
        });
        return defer.promise;
    };

    // 更新报送分类B
    $scope.updateBaosongB = function(field, value) {
        var params = { baosong_b: {}};
        params.baosong_b[field] = value;

        $http.put('/baosong_bs/' + $scope.baosong_b.id + '.json', params).then(function(res){
            console.log(res);
        }, function(){});
    };

    $scope.addCategory = {
				//添加食品大类 (数据)
        addACategory: function (collection) {
						if (!confirm('确定添加所选项吗？')) {
            	return false;
        		}
						
        		var names = [];
        		angular.forEach(collection, function (c) {
        		  if (!!c.checked) {
        		    names.push(c.name);
        		    c.enable = false;
								c.checked = false;
        		  }
        		});
						
						if (names.length == 0){
							alert("提交前请选择");
							return false;
						}
						
            $http.post('/create_categorys/ACategory.json', {
              identifier: $scope.baosong_b.identifier,
              names: names.join(',')
            }).then(function (res) {
              if (res.data.status == 'OK') {
                upadte_list("ACategory",$scope.baosong_b.identifier,$scope.a_categories);
								alert("添加成功！");
              } else {
                alert(res.data.msg.join(','));
              }
            }, function () {
              alert('添加请求失败！');
            });
						names = [];
        },
				//添加食品亚类、食品次亚类、食品细类(类型、对象、上级ID)
        addOtherCategory: function (category, collection, parent_category_id) {
						console.log(category, collection, parent_category_id);
						var obj_status = false;
						if (!confirm('确定添加所选项吗？')) {
            	return false;
        		}

						//提交前判断是否选择上级
        		switch (category) {
        		  case 'BCategory':
								obj = $scope.a_categories; 
        		    break;
        		  case 'CCategory':
								obj = $scope.b_categories;
        		    break;
        		  case 'DCategory':
								obj = $scope.c_categories;
        		    break;
        		}
						angular.forEach(obj, function (o) {
							if (o.id == parent_category_id && o.enable==true) {
								alert("请先选择上级");
								obj_status = true;
							}
						});
						if (obj_status){
							return false;
						}
        		var names = [];
        		angular.forEach(collection, function (c) {
        		  if (!!c.checked) {
        		    names.push(c.name);
        		    c.enable = false;
								c.checked = false;
        		  }
        		});

						if (names.length == 0){
							alert("提交前请选择");
							return false;
						}
						//渲染本级选框
            $http.post('/create_categorys/' + category + '.json', {
								identifier: $scope.baosong_b.identifier,
                selected_name: $scope.selected_name,
                names: names.join(',')
            }).then(function (res) {
                if (res.data.status == 'OK') {
									upadte_list("b_category",$scope.baosong_b.identifier,obj,$scope.selected_name);
									alert("添加成功！");
                } else {
                  alert(res.data.msg);
                }
            }, function () {
                alert('添加请求失败！');
            });
						names = [];
        }
    };
		
		//更新报送分类选项(分类类型,报送B编码,该分类对象,类型名称)
		function upadte_list(category,identifier,obj,selected_name) {
			$http.get('/query_category/' + category + '.json', {params:{identifier: identifier, selected_name: selected_name}}).then(function (res) {
				//实现区分是否选中
				var names = res.data.msg
				angular.forEach(obj, function (c) {
						angular.forEach(names, function (n) {
						  if (c.name == n) {
							  c.enable=false;
						  }	
						})
				});
			}, function () {
				alert('更新选框失败！');
			});
		}
		
    /**
     * 压包 CHECK ITEMS
     * */
    function pack_check_items(check_items) {
        var items = [];
        angular.forEach(check_items, function (i) {
            var item = {};
            item.id = i.id;
            item.name = i.name;
            item.JGDW = i.JGDW;
            item.PDYJ = i.PDYJ.join("#");

            item.JYYJ = _.uniq(_.map(i.options, function (o) {
                return o.JYYJ
            })).join("#");
            item.BZFFJCX = _.uniq(_.map(i.options, function (o) {
                return o.BZFFJCX
            })).join("#");
            item.BZFFJCXDW = _.uniq(_.map(i.options, function (o) {
                return o.BZFFJCXDW
            })).join("#");
            item.BZZXYXX = _.uniq(_.map(i.options, function (o) {
                return o.BZZXYXX
            })).join("#");
            item.BZZXYXXDW = _.uniq(_.map(i.options, function (o) {
                return o.BZZXYXXDW
            })).join("#");
            item.BZZDYXX = _.uniq(_.map(i.options, function (o) {
                return o.BZZDYXX
            })).join("#");
            item.BZZDYXXDW = _.uniq(_.map(i.options, function (o) {
                return o.BZZDYXXDW
            })).join("#");

            items.push(item);
        });
        return items;
    }

    /**
     * 解包CHECK ITEMS
     * */
    function unpack_check_items(items) {
        angular.forEach(items, function (item) {
            item.options = [];
            item.PDYJ = item.PDYJ.split("#");

            var max_$_count = 0;
            if (!!item.JYYJ) {
                item.JYYJ = item.JYYJ.split("#")

                if (max_$_count < item.JYYJ.length) {
                    max_$_count = item.JYYJ.length;
                }
            }

            if (!!item.BZFFJCX) {
                item.BZFFJCX = item.BZFFJCX.split("#")
                if (max_$_count < item.BZFFJCX.length) {
                    max_$_count = item.BZFFJCX.length;
                }
            }

            if (!!item.BZFFJCXDW) {
                item.BZFFJCXDW = item.BZFFJCXDW.split("#")

                if (max_$_count < item.BZFFJCXDW.length) {
                    max_$_count = item.BZFFJCXDW.length;
                }
            }

            if (!!item.BZZXYXX) {
                item.BZZXYXX = item.BZZXYXX.split("#")

                if (max_$_count < item.BZZXYXX.length) {
                    max_$_count = item.BZZXYXX.length;
                }
            }

            if (!!item.BZZXYXXDW) {
                item.BZZXYXXDW = item.BZZXYXXDW.split("#")

                if (max_$_count < item.BZZXYXXDW.length) {
                    max_$_count = item.BZZXYXXDW.length;
                }
            }

            if (!!item.BZZDYXX) {
                item.BZZDYXX = item.BZZDYXX.split("#")

                if (max_$_count < item.BZZDYXX.length) {
                    max_$_count = item.BZZDYXX.length;
                }
            }

            if (!!item.BZZDYXXDW) {
                item.BZZDYXXDW = item.BZZDYXXDW.split("#")

                if (max_$_count < item.BZZDYXXDW.length) {
                    max_$_count = item.BZZDYXXDW.length;
                }
            }

            // 分拆各选项
            _.times(max_$_count, function (n) {
                var option = {};

                if (!!item.JYYJ[n]) {
                    option.JYYJ = item.JYYJ[n];
                } else {
                    option.JYYJ = _.last(item.JYYJ);
                }

                if (!!item.BZFFJCX[n]) {
                    option.BZFFJCX = item.BZFFJCX[n];
                } else {
                    option.BZFFJCX = _.last(item.BZFFJCX);
                }

                if (!!item.BZFFJCXDW[n]) {
                    option.BZFFJCXDW = item.BZFFJCXDW[n];
                } else {
                    option.BZFFJCXDW = _.last(item.BZFFJCXDW);
                }

                if (!!item.BZZXYXX[n]) {
                    option.BZZXYXX = item.BZZXYXX[n];
                } else {
                    option.BZZXYXX = _.last(item.BZZXYXX);
                }

                if (!!item.BZZXYXXDW[n]) {
                    option.BZZXYXXDW = item.BZZXYXXDW[n];
                } else {
                    option.BZZXYXXDW = _.last(item.BZZXYXXDW);
                }

                if (!!item.BZZDYXX[n]) {
                    option.BZZDYXX = item.BZZDYXX[n];
                } else {
                    option.BZZDYXX = _.last(item.BZZDYXX);
                }

                if (!!item.BZZDYXXDW[n]) {
                    option.BZZDYXXDW = item.BZZDYXXDW[n];
                } else {
                    option.BZZDYXXDW = _.last(item.BZZDYXXDW);
                }

                item.options.push(option);
            });
        });
        return items;
    }

    // 加载检测项目
    function load_check_items() {
        $http.get("/baosong_bs_newests/check_items?d_category_id=" + $scope.selected.d_category_id).then(function (res) {
            $scope.check_items = unpack_check_items(res.data.items);
        }, function () {
        });
    }

    /**
     * 加载分类
     * @param category
     * */
    function load_categories(category) {
        var params = angular.copy($scope.selected);
        params.type = category;

        $scope.is_editing_a = false;
        $scope.is_editing_b = false;
        $scope.is_editing_c = false;
        $scope.is_editing_d = false;

        $http.get("/baosong_bs_newests/categories.json", {params: params}).then(function (res) {
            delete $scope.check_items;
            switch (category) {
                case 'a_category_id':
                    $scope.b_categories = res.data.msg;
                    delete $scope.c_categories;
                    delete $scope.d_categories;
                    break;
                case 'b_category_id':
                    $scope.c_categories = res.data.msg;
                    delete $scope.d_categories;
                    break;
                case 'c_category_id':
                    $scope.d_categories = res.data.msg;
                    break;
                case 'd_category_id':
                    $scope.items = res.data.items;
                    break;
            }
        }, function () {
        });
    }

    $http.get("/baosong_bs_newests/categories.json").then(function (res) {
        $scope.a_categories = res.data.msg;
				upadte_list("ACategory",$scope.baosong_b.identifier,$scope.a_categories);
    }, function () {
    });
}]);

app.controller('TCtrl', ['$scope', '$http', function ($scope, $http) {

}]);
