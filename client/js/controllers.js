'use strict';

/* Controllers */
var mainControllers = angular.module('mainControllers', []);

mainControllers.controller('HeaderCtrl', ['$scope','$location','$route','$http',
  function($scope,$location,$route,$http) {

 	//ドロップダウン
	$("#nav" ).hover(function() {
		$("ul#nav_menu").show();
	}, function() {
		$("ul#nav_menu").hide();
	});


	//ユーザー情報取得
	$http({
	    method : 'GET',
	    url : 'http://omoide.folder.jp/api/users',
		headers: { "X-Requested-With": "XMLHttpRequest" },
	}).success(function(data, status, headers, config) {
		$scope.user = data['response']['User'];
	}).error(function(data, status, headers, config) {
	    console.log('failed!');
	});

	//ログアウト
	$scope.logout = function(){
        $http({
			method : 'GET',
		    url : 'http://omoide.folder.jp/api/users/logout',
			headers: {
				'X-Requested-With': 'XMLHttpRequest',
	    		'Content-Type': 'application/x-www-form-urlencoded'
	    	},
		}).success(function(data, status, headers, config) {
			console.log('ok:)');
			location.href = '//omoide.folder.jp';
		}).error(function(data, status, headers, config) {
			console.log('error!');
		});
    };

  }]
);

mainControllers.controller('UserLoginCtrl', ['$scope','$location','$http',
  function($scope,$location,$http) {

  	$scope.login = function(){
      $scope.disabled = true;

	 	 	var data = {
	 	 		'address': $scope.address,
	 	 		'password': $scope.password,
	 	 	};

			$http({
				method : 'POST',
			    url : 'http://omoide.folder.jp/api/users/login',
				headers: {
					'X-Requested-With': 'XMLHttpRequest',
		    		'Content-Type': 'application/x-www-form-urlencoded',
                    "Accept": "application/json",
		    	},
				data: $.param(data)
			}).success(function(data, status, headers, config) {
				console.log(data);
				location.href = 'mypage';
			}).error(function(data, status, headers, config) {
				console.log('error!');
			});
    };

  }]
);

mainControllers.controller('UserSignupCtrl', ['$scope','$location','$http',
  function($scope,$location,$http) {

  	$scope.signup = function(){
      $scope.disabled = true;

	 	 	var data = {
	 	 		'address': $scope.address,
	 	 		'password': $scope.password,
	 	 	};

			$http({
				method : 'POST',
			    url : 'http://omoide.folder.jp/api/users/signup.json',
				headers: {
					'X-Requested-With': 'XMLHttpRequest',
		    		'Content-Type': 'application/x-www-form-urlencoded',
		    	},
				data: $.param(data)
			}).success(function(data, status, headers, config) {
				console.log(data);
				location.href = 'mypage';
			}).error(function(data, status, headers, config) {
				console.log('error!');
			});
    };

  }]
);

mainControllers.controller('NewTalkCtrl', ['$scope','$location', '$http',
  function($scope, $location, $http) {
		//トークアップロード
		$scope.upload = function(form){
			console.log('upload start…');

            var $form = $('#upload');
            var formData = new FormData($form[0]);

            $.ajax('http://omoide.folder.jp/api/talks/add',
                {
                    type: 'post',
                    async: false,
                    processData: false,
                    contentType: 'application/json',
                    data: formData,
                    dataType: 'json',
                    success: function(data) {
                        console.log(data['response']);
                        //location.href = '/';
                    },
                    error: function(data) {
                        console.log(data['response']);
                    }
                }
            );

    };

  }]
);

mainControllers.controller('TalkListCtrl', ['$scope', '$http',
  function($scope, $http) {
		//トークリスト取得
		$http({
			method : 'GET',
			cache: true,
			url : 'http://omoide.folder.jp/api/talks',
			headers: {
                "X-Requested-With": "XMLHttpRequest",
                "Accept": "application/json",
            },
		}).success(function(data) {
			$scope.talk = data['response']['Talk'];
		}).error(function(data) {
		    console.log('failed!');
		});

		//日付パース
		$scope.parseDate = function(d) {
	    	return Date.parse(d);
		};
  }]
);

mainControllers.controller('TalkViewCtrl', ['$scope', '$routeParams', '$http',
	function($scope, $routeParams, $http) {
		//現在日時取得
		var now = new Date();
		$scope.year = now.getFullYear();
		$scope.month = now.getMonth()-2;

		var $id= $routeParams.id;

		//json取得(非同期)
		$http({
			method : 'GET',
			cache: true,
			url : 'http://omoide.folder.jp/api/talks/'+$id,
            headers: {
                "X-Requested-With": "XMLHttpRequest",
                "Accept": "application/json",
            },
		}).success(function(data, status, headers, config) {
			$scope.head = data['response']['head'];
			$scope.member = data['response']['member'];

            //自分の名前
            $scope.selectedName = $scope.member[0];
            $("#title_num").text($scope.selectedName['name'].length+"/20");

			var timeline = data['response']['timeline'];
			$scope.count = timeline[$scope.year][$scope.month].length;
			$scope.timeline = timeline[$scope.year][$scope.month];

			//年月指定
			$scope.setDate = function(year,month) {
				$scope.year = year;
				$scope.month = month;
				$scope.timeline = timeline[$scope.year][$scope.month];
			};

			//メンバー数
			var num = $scope.member.length;
			if(num > 5) {
				$("#member ul").append("<li class='more'>全て表示("+num+")</li>");
			}

		}).error(function(data, status, headers, config) {
		    console.log('failed!');
		});

		//日付パース
		$scope.parseDate = function(d) {
			return Date.parse(d);
		};

	}]
);

mainControllers.controller('TalkSettingCtrl', ['$scope', '$routeParams', '$http',
    function($scope, $routeParams, $http) {

        //タイトル文字数表示
        $(".text").bind("change keyup",function(){
            var count = $(this).val().length;
            $("#title_num").text(count+"/20");

            if(count>20) {
                $("#title_num").css({"color":"red"});
            } else {
                $("#title_num").css({"color":""});
            }
        });

    }]
);
