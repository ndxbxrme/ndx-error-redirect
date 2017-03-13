'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx-error-redirect', []
module.factory 'errorRedirect', ($rootScope) ->
  errors = ['AUTH_REQUIRED', 'FORBIDDEN', 'UNAUTHORIZED']
  redirect = 'error'
  passError = false
  $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
    console.log 'error', error
    if errors.indexOf(error) isnt -1
      params = null
      if passError
        params =
          error: error
      $state.go redirect, params
  setErrors: (_errors) ->
    errors = _errors
  setRedirect: (state) ->
    redirect = state
  passError: passError