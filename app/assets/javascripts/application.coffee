#= require jquery
#= require jquery_ujs
#= require foundation
#= require websocket_rails/main

$ ->
  $(document).foundation(
    orbit: {
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
    perc = parseInt(task.month) * 100 / 12
    $("span.meter").css('width', "#{perc}%")

    member_pos = find_member_pos(task)
    $("#slider-#{parseInt(task.message) - 1}").trigger("orbit.stop").trigger("orbit.goto", member_pos);
  )

  find_member_pos = (task) ->
    member_name = task.member[0]
    console.log(member_name)
    list_item = $(".orbit-caption:contains('#{member_name}')").first().parent()
    console.log(list_item)
    console.log($("#slider-0").find('li').index(list_item))
    return $("#slider-0").find('li').index(list_item)

  $(".alert-box").delay(1500).fadeOut "slow"
