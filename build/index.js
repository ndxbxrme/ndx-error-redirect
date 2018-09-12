(function() {
  'use strict';
  var e, error1, module;

  module = null;

  try {
    module = angular.module('ndx');
  } catch (error1) {
    e = error1;
    module = angular.module('ndx', []);
  }

  module.provider('ErrorRedirect', function() {
    var errors, globalIgnore;
    errors = {
      401: {
        state: 'logged-out',
        ignore: [/\/forgot/, /\/logged-out/]
      }
    };
    globalIgnore = [/\/forgot/, /\/invite/];
    return {
      config: function(args) {
        var results, status;
        if (args.errors) {
          results = [];
          for (status in args.errors) {
            results.push(errors[status] = args.errors[status]);
          }
          return results;
        }
      },
      $get: function($injector, $q, $window, $location, $timeout) {
        return {
          request: function(config) {
            return config;
          },
          response: function(config) {
            return config;
          },
          responseError: function(rejection) {
            var $state, error, i, ignore, j, len, len1, ref, regex, status;
            $state = $injector.get('$state');
            for (status in errors) {
              if (+status === rejection.status) {
                error = errors[status];
                ignore = false;
                for (i = 0, len = globalIgnore.length; i < len; i++) {
                  regex = globalIgnore[i];
                  if (regex.test($location.path())) {
                    ignore = true;
                    break;
                  }
                }
                if (!ignore) {
                  ref = error.ignore;
                  for (j = 0, len1 = ref.length; j < len1; j++) {
                    regex = ref[j];
                    if (regex.test($location.path())) {
                      ignore = true;
                      break;
                    }
                  }
                  if (!ignore) {
                    if ($state.current.name !== error.state) {
                      $timeout(function() {
                        return $location.path(error.state);
                      }, 10);
                      $q.resolve('error');
                      return false;
                    }
                  }
                }
                break;
              }
            }
            return rejection;
          }
        };
      }
    };
  }).config(function($httpProvider) {
    return $httpProvider.interceptors.unshift('ErrorRedirect');
  });

}).call(this);

//# sourceMappingURL=index.js.map
