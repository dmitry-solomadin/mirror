window.Widgets = ->

  AUTOUPDATE_INTERVAL: 30 * 60 * 1000 # 30 minutes

  VERSION_UPDATE_INTERVAL: 30 * 60 * 1000 # 30 minutes

  init: ->
    setInterval (-> widgets.checkDashboardVersion()), widgets.VERSION_UPDATE_INTERVAL

  checkDashboardVersion: ->
    $.ajax
      url: $('.js-dashboard-url').val(),
      dataType: 'json',
      success: (result) ->
        currentVersion = parseInt($('.js-dashboard-version').val())
        if result.version && result.version != currentVersion
          window.location.reload()

$(document).on 'ready page:load', ->
  window.widgets = Widgets()
  widgets.init()
