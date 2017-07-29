(function() {
  'use strict';
  var e, error, module;

  module = null;

  try {
    module = angular.module('ndx');
  } catch (error) {
    e = error;
    module = angular.module('ndx', []);
  }

  module.provider('ErrorRedirect', function() {
    var errorState;
    errorState = 'error';
    return {
      errorState: function(_errorState) {
        return errorState = _errorState;
      },
      $get: function($state) {
        return {
          responseError: function(rejection) {
            if (rejection.status === 401) {
              $state.go(errorState);
            }
            return rejection;
          }
        };
      }
    };
  }).config(function($httpProvider) {
    return $httpProvider.interceptors.push('ErrorRedirect');
  });

}).call(this);

//# sourceMappingURL=index.js.map
