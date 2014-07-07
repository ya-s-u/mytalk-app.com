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

            $.ajax('http://omoide.folder.jp/api/talks',
                {
                    type: 'post',
                    async: false,
                    processData: false,
                    contentType: false,
                    data: formData,
                    dataType: 'json',
                    success: function(data) {
                        console.log(data['response']);
                        location.href = '/mypage';
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

        //日付フォーマット
        var formatDate = function (date, format) {
          format = format.replace(/YYYY/g, date.getFullYear());
          format = format.replace(/MM/g, date.getMonth()+1);
          return format;
        };

        //トークID
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

            //年月指定
            $scope.year = formatDate(new Date($scope.head['end']),'YYYY');
            $scope.month = formatDate(new Date($scope.head['end']),'MM');

            //自分の名前
            $scope.selectedName = $scope.member[0];
            $("#title_num").text($scope.selectedName['name'].length+"/20");

            $scope.timeline = data['response']['timeline'][$scope.year][$scope.month];
			$scope.count = $scope.timeline.length;

            //1つ前の年月取得
            function getPrev(year,month) {
                if(""+year+month == formatDate(new Date($scope.head['start']),'YYYYMM')) {
                    $scope.prevYear = null;
                    $scope.prevMonth = null;
                } else {
                    if(month-1 == 0) { year--; month = 12;} else { month--;}

                    if(data['response']['timeline'][year][month]) {
                        $scope.prevYear = year;
                        $scope.prevMonth = month;
                    } else {
                        getPrev(year,month-1);
                    }
                }
            }

            //1つ後の年月取得
            function getNext(year,month) {
                if(""+year+month == formatDate(new Date($scope.head['end']),'YYYYMM')) {
                    $scope.nextYear = null;
                    $scope.nextMonth = null;
                } else {
                    if(month+1 == 12) { year++; month = 1;} else { month++;}

                    if(data['response']['timeline'][year][month]) {
                        $scope.nextYear = year;
                        $scope.nextMonth = month;
                    } else {
                        getNext(year,month-1);
                    }
                }
            }

            getPrev($scope.year,$scope.month);
            getNext($scope.year,$scope.month);

			//年月指定
			$scope.setDate = function(year,month) {
				$scope.year = year;
				$scope.month = month;
				$scope.timeline = data['response']['timeline'][$scope.year][$scope.month];
                getPrev(year,month);
                getNext(year,month);
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

        //スクロール制御
        $(window).scroll(function () {
            var ScrTop = $(document).scrollTop();

            if(ScrTop > 50) {
                //$("#header").css({"position":"fixed","z-index":"100"});
                $("#header").css({"position":"fixed","top":"-50px"});
                $("#top").css({"position":"fixed","top":"5px"});
                $("#left").css({"position":"fixed","opacity":"0.5"});
                $("#talk").css({"position":"absolute","top":"50px"});
                $("#head").css({"position":"fixed","top":"80","box-shadow":"0 1px 1px rgba(200,200,200,.5)"});
            } else {
                $("#header").css({"position":"inherit"});
                $("#top").css({"position":"absolute","top":"0"});
                $("#left").css({"position":"absolute","opacity":"1.0"});
                $("#talk").css({"position":"inherit","top":"0"});
                $("#head").css({"position":"absolute","top":"0","box-shadow":"none"});
            }
        });

        //読み込み済みモーダルリスト
        var LoadedModal = [];

        //モーダル読み込み
        $scope.ShowModal = function(ModalId) {
            $scope.TalkModal = 'modals/'+ModalId+'.html';
            if($.inArray(ModalId,LoadedModal) >= 0) {
                $scope.OpenModal();
            } else {
                LoadedModal.push(ModalId);
            }
        };

        //モーダルオープン
        $scope.OpenModal = function() {
            $('body').append('<div id="overlay"></div>').css({"overflow":"hidden"});
            centering();
            $('#overlay,.modal').show();
            $('.modal').append("<p class='close'><span class='icon-times'></span></p>");

            //スマホスクロール禁止
            $(window).on('touchmove.noScroll',function(e) {
                e.preventDefault();
            })

            //ウィンドウリサイズ後にセンタリング
            var timer = false;
            $(window).resize(function() {
                if (timer !== false) {
                    clearTimeout(timer);
                }
                timer = setTimeout(function() {
                    centering();
                }, 200);
            });

            //モーダルを閉じる
            $('#overlay,.close').click(function(){
                $('#overlay,.modal').hide();
                $('#overlay').remove();
                $('body').css({"overflow":"auto"});
                $(window).off('.noScroll');
            });

            function centering() {
                var header_height = $('#header').outerHeight();
                var box_width = $('.modal').outerWidth();
                var box_height = $('.modal').outerHeight();
                //var window_width = $(window).outerWidth();
                var window_height = $(window).outerHeight();
                var top = (window_height-box_height)/2-header_height;
                var left = (1000-box_width)/2;
                $('.modal').css({"top":top,"left":left});
            };
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

        //トーク削除ボタン
        $scope.DeleteTalk = function(){
            if(window.confirm('本当に削除しますか？')) {
                $http({
                    method : 'DELETE',
                    url : 'http://omoide.folder.jp/api/talks/'+$routeParams.id,
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Content-Type': 'application/x-www-form-urlencoded',
                        "Accept": "application/json",
                    },
                }).success(function(data, status, headers, config) {
                    alert('削除しました！');
                    location.href = 'mypage';
                }).error(function(data, status, headers, config) {
                    console.log('error!');
                });
        	}
        };

    }]
);
