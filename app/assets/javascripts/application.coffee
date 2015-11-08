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
      member_pos = sliders[i].parent().parent().parent().data('best-pos')
      if member_pos != -1 && member_pos != null
        sliders[i].goToSlide(member_pos)
    else
      sliders[i].startAuto()

  ws_url = $('#employee-ul').data('ws-url')
  dispatcher = new WebSocketRails(ws_url)
  channel = dispatcher.subscribe('sync')

  channel.bind('syncer.started', (message) ->
    org_name = $('#organization-row').data('organization-name')
    return if org_name == '' || org_name == null
    return if org_name != message.org_name
    for slider in sliders
      slider.stopAuto()
      slider.goToSlide(0)
      slider.startAuto()
  )

  channel.bind('syncer.progress', (progress) ->
    org_name = $('#organization-row').data('organization-name')
    return if org_name == '' || org_name == null
    return if org_name != progress.org_name
    $("span.meter").css('width', "#{progress.prog}%")
    if progress.prog == 100
      setTimeout(() ->
        $("span.meter").parent().parent().addClass('hide')
        $('.sync-button').show()
      , 250)
  )

  channel.bind('syncer.yearly', (yearly) ->
    org_name = $('#organization-row').data('organization-name')
    return if org_name == '' || org_name == null
    return if org_name != yearly.org_name
    if yearly.pos != -1
      sliders[parseInt(yearly.month) - 1].stopAuto()
      sliders[parseInt(yearly.month) - 1].goToSlide(parseInt(yearly.pos))
  )

  channel.bind('syncer.repos', (repos) ->
    org_name = $('#organization-row').data('organization-name')
    return if org_name == '' || org_name == null
    return if org_name != repos.org_name
    $('.repo-count').html(repos.repo_count)
  )

  $(".alert-box").delay(1500).fadeOut "slow"
