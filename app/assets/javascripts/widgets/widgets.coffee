window.Widgets = ->

  AUTOUPDATE_INTERVAL: 30 * 60 * 1000 # 30 minutes

$(document).on 'ready page:load', ->
  window.widgets = Widgets()
