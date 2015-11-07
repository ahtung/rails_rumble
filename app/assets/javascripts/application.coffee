#= require jquery
#= require jquery_ujs
#= require foundation
#= require websocket_rails/main

$ ->
  $(document).foundation(
    orbit: {
      timer_speed: 230,
      navigation_arrows: false,
      slide_number: false,
      pause_on_hover: false,
      swipe: false,
      bullets: false
    }
  )

  dispatcher = new WebSocketRails('localhost:3000/websocket')
  channel = dispatcher.subscribe('sync')
  channel.bind('syncer', (task) ->
    perc = parseInt(task.message) * 100 / 12
    $("span.meter").css('width', "#{perc}%")
    $("#slider-#{parseInt(task.message) - 1}").trigger('orbit.stop', 3)
    $("#slider-#{parseInt(task.message) - 1}").trigger('orbit.goto', 3)
  )

  $(".alert-box").delay(1500).fadeOut "slow"
