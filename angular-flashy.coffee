angular.module('angularFlashy')
  .service 'flash', ($timeout, $rootScope) ->
    class Flash
      constructor: ->
        @queue = []
        @current: null
        @default_duration: 5000 #ms

      permanent: (message, type = 'success') ->
        notify(message, type)

      notify: (message, type) ->
        @current =
          message: message
          type: type
        $rootScope.$broadcast('flash', @current)

      temporary: (message, type, duration) -> #duration in ms
        if type is null
          type = 'success'
          duration = @default_duration
        else if typeof type is 'number'
          duration = type
          type = 'success'
        notify(message, type)
        $timeout((=> @current = null), duration)

    return new Flash()

  .directive 'flash', ->
    restrict: 'E'
    link: ($scope, element) ->
      currentType = null
      $scope.$on 'flash', (notification) ->
        if notification.type isnt currentType
          element.removeClass(currentType)
          element.addClass(notification.type)
          currentType = notification.type

        element.text(notification.message)

      $scope.$on 'flash-off', ->
        element.text('')











