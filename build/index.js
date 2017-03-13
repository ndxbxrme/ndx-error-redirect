(function() {
  'use strict';
  var e, error1, module;

  module = null;

  try {
    module = angular.module('ndx');
  } catch (error1) {
    e = error1;
    module = angular.module('ndx-error-redirect', []);
  }

  module.factory('errorRedirect', function($rootScope) {
    var errors, passError, redirect;
    errors = ['AUTH_REQUIRED', 'FORBIDDEN', 'UNAUTHORIZED'];
    redirect = 'error';
    passError = false;
    $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams, error) {
      var params;
      console.log('error', error);
      if (errors.indexOf(error) !== -1) {
        params = null;
        if (passError) {
          params = {
            error: error
          };
        }
        return $state.go(redirect, params);
      }
    });
    return {
      setErrors: function(_errors) {
        return errors = _errors;
      },
      setRedirect: function(state) {
        return redirect = state;
      },
      passError: passError
    };
  });

}).call(this);

//# sourceMappingURL=index.js.map
