'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx', []
module.provider 'ErrorRedirect', ->
  errors =
    401:
      state: 'logged-out'
      ignore: [/\/forgot/, /\/logged-out/]
  globalIgnore = [/\/forgot/, /\/invite/, /\/refresh-login/]
  config: (args) ->
    if args.errors
      for status of args.errors
        errors[status] = args.errors[status]
    #globalIgnore = args.globalIgnore or errors
  $get: ($injector, $q, $window, $location, $timeout) ->
    request: (config) ->
      config
    response: (config) ->
      config
    responseError: (rejection) ->
      $state = $injector.get '$state'
      for status of errors
        if +status is rejection.status
          error = errors[status]
          ignore = false
          for regex in globalIgnore
            if regex.test $location.path()
              ignore = true
              break
          if not ignore
            for regex in error.ignore
              if regex.test $location.path()
                ignore = true
                break
            if not ignore
              if $state.current.name isnt error.state
                $timeout ->
                  $location.path error.state
                , 50
                $q.resolve('error')
                return false
          break
      rejection
.config ($httpProvider) ->
  $httpProvider.interceptors.unshift 'ErrorRedirect'