'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx', []
module.provider 'ErrorRedirect', ->
  console.log 'hoooow'
  loggedOutState = 'logged-out'
  loggedOutState: (_loggedOutState) ->
    loggedOutState = _loggedOutState
  maintenanceState = 'maintenance'
  maintenanceState: (_maintenanceState) ->
    maintenanceState = _maintenanceState
  $get: ($state, $q) ->
    responseError: (rejection) ->
      console.log $state.current
      if $state.current.name
        if rejection.status is 401
          if $state.current.name isnt loggedOutState
            $state.go loggedOutState
        if rejection.status is 503
          if $state.current.name isnt maintenanceState
            $state.go maintenanceState
      rejection
.config ($httpProvider) ->
  $httpProvider.interceptors.unshift 'ErrorRedirect'