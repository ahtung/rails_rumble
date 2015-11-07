#= require jquery
#= require jquery_ujs
#= require foundation
#= require websocket_rails/main

$ ->
  $(document).foundation(
    orbit: {
      timer_speed: 1000
    }
  )

  dispatcher = new WebSocketRails('localhost:3000/websocket')
  channel = dispatcher.subscribe('sync')
  channel.bind('syncer', (task) ->
    perc = parseInt(task.message) * 100 / 12
    $("span.meter").css('width', "#{perc}%")
  )
