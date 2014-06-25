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
	    url : 'http://omoide.folder.jp/api/users/getUser.json',
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
		    url : 'http://omoide.folder.jp/api/users/logout.json',
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
			    url : 'http://omoide.folder.jp/api/users/signin.json',
				headers: {
					'X-Requested-With': 'XMLHttpRequest',
		    		'Content-Type': 'application/x-www-form-urlencoded'
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
		    		'Content-Type': 'application/x-www-form-urlencoded'
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

			var $form = $('#newtalk');
			var fd = new FormData($form[0]);

			$.ajax(
				'http://omoide.folder.jp/api/talks/newTalk.json',
				{
					type: 'post',
					async: false,
					processData: false,
					contentType: false,
					data: fd,
					dataType: "json",
					success: function(data) {
						console.log(data['response']);
						location.href = '/';
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
			url : 'http://omoide.folder.jp/api/talks/getList.json',
			headers: { "X-Requested-With": "XMLHttpRequest" },
		}).success(function(data, status, headers, config) {
			$scope.talk = data['response']['Talk'];
		}).error(function(data, status, headers, config) {
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
		$scope.month = now.getMonth()-1;

		var $id= $routeParams.id;

		//json取得(非同期)
		$http({
			method : 'GET',
			cache: true,
			url : 'http://omoide.folder.jp/api/talks/getTalk.json?id='+$id,
			headers: { "X-Requested-With": "XMLHttpRequest" },
		}).success(function(data, status, headers, config) {
			$scope.head = data['response']['head'];
			$scope.member = data['response']['member'];

			var temp = data['response']['temp'];
			$scope.count = temp[$scope.year][$scope.month].length;
			$scope.timeline = temp[$scope.year][$scope.month];

			//年月指定
			$scope.setDate = function(year,month) {
				$scope.year = year;
				$scope.month = month;
				$scope.timeline = temp[$scope.year][$scope.month];
			};

			//最下部までスクロール
			$('html').animate({
				scrollTop: 999999,
			});

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
