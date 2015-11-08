#= require jquery
#= require jquery_ujs
#= require foundation
#= require websocket_rails/main
#= require bxslider-4

$ ->
  $(document).foundation()

  update_slider = (org) ->
    sliders[parseInt(org.month) - 1].stopAuto()
    sliders[parseInt(org.month) - 1].goToSlide(parseInt(org.pos))

  update_progress = (prog) ->
    $("span.meter").css('width', "#{prog}%")
    if prog == 100
      setTimeout(() ->
        $("span.meter").parent().parent().addClass('hide')
        $('.sync-button').removeAttr("disabled")
      , 250)

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
      member_pos = sliders[i].parent().parent().parent().data('best-pos')
      if member_pos != -1 && member_pos != null
        sliders[i].goToSlide(member_pos)
    else
      sliders[i].startAuto()

  ws_url = $('#employee-ul').data('ws-url')
  dispatcher = new WebSocketRails(ws_url)
  channel = dispatcher.subscribe('sync')

  channel.bind('syncer', (task) ->
    org_name = $('#organization-row').data('organization-name')
    return if org_name == '' || org_name == null
    return if org_name != task.org_name
    update_progress(task.prog)
    update_slider(task)
  )

  $(".alert-box").delay(1500).fadeOut "slow"
