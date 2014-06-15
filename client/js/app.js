'use strict';


var clientApp = angular.module('clientApp', [
	'ngRoute',
	'ngResource',
	'mainControllers',
]);


clientApp.config(['$routeProvider','$locationProvider',
	function($routeProvider,$locationProvider) {
  
		//$locationProvider.hashPrefix('!');
		//$locationProvider.html5Mode(true);
		
		$routeProvider
		.when('/', {
			templateUrl: 'partials/talk-list.html',
			controller: 'TalkListCtrl'
		})
		.when('/view/:id', {
			templateUrl: 'partials/talk-view.html',
			controller: 'TalkViewCtrl'
		})
		.otherwise({
			redirectTo: '/',
		});
	}
]);


clientApp.factory('AuthService',
	function($q, $http) {
    var user = null;
    
    return {
		isLogged: function() {
			return !!user;
		},
      
		getUser: function() {
			return user;
		},
      
		login: function(address, password){
			var data = {
				'address': address,
				'password': password,
			};
			
			var deferred = $q.defer();
			
			$http({
				method : 'POST',
				url : 'http://omoide.folder.jp/api/users/signin.json',
				headers: {
					'X-Requested-With': 'XMLHttpRequest',
					'Content-Type': 'application/x-www-form-urlencoded'
				},
				data: $.param(data)
			}).success(function(data, status, headers, config) {
				user = {
					username: username
				};
				deferred.resolve();
			}).error(function(data, status, headers, config) {
				deferred.reject();
			});
			
			return deferred.promise;
		},
      
		logout: function(){
			$http({
				method : 'GET',
				url : 'http://omoide.folder.jp/api/users/logout.json',
				headers: {
					'X-Requested-With': 'XMLHttpRequest',
					'Content-Type': 'application/x-www-form-urlencoded'
				},
			}).success(function(data, status, headers, config) {
				user = null;
				return $q.all();
			}).error(function(data, status, headers, config) {
				console.log('error!');
			});
		}
      
    };
});
