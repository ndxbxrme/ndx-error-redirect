'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx', []
module.provider 'ErrorRedirect', ->
  errorState = 'error'
  errorState: (_errorState) ->
    errorState = _errorState
  $get: ($state, $q) ->
    responseError: (rejection) ->
      if rejection.status is 401
        $state.go errorState
      $q.reject rejection
.config ($httpProvider) ->
  $httpProvider.interceptors.unshift 'ErrorRedirect'