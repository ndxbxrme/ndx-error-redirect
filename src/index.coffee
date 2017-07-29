'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx-error-redirect', []
module.provider 'ErrorInterceptor', ->
  errorState = 'error'
  errorState: errorState
  $get: ($state) ->
    responseError: (rejection) ->
      if rejection.status is 401
        $state.go errorState
      rejection
.config ($httpProvider) ->
  $httpProvider.interceptors.push 'ErrorInterceptor'