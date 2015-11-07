#= require jquery
#= require jquery_ujs
#= require foundation
#= require websocket_rails/main
#= require bxslider-4

$ ->
  $(document).foundation()

  sliders = []
  $('.bxslider').each (i, obj) ->
    sliders[i] = $(this).bxSlider(
      auto: false,
      speed: 200,
      pause: 500,
      controls: false,
      pager: false,
      captions: true
    )

    if sliders[i].data('complete')
      sliders[i].stopAuto()
    else
      sliders[i].startAuto()



  dispatcher = new WebSocketRails('localhost:3000/websocket')
  channel = dispatcher.subscribe('sync')
  channel.bind('syncer', (task) ->
    perc = parseInt(task.month) * 100 / 12
    $("span.meter").css('width', "#{perc}%")

    member_pos = find_member_pos(task)
    if member_pos != -1
      sliders[parseInt(task.month) - 1].stopAuto()
      sliders[parseInt(task.month) - 1].goToSlide(member_pos + 1)
  )

  find_member_pos = (task) ->
    member_name = task.member[0]
    list_item = $("img[title='#{member_name}']").first().parent()
    return $("#slider-0").find('li').index(list_item)

  $(".alert-box").delay(1500).fadeOut "slow"
