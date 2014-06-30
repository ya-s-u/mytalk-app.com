'use strict';


var clientApp = angular.module('clientApp', [
	'ngRoute',
	'ngResource',
	'ngSanitize',
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
