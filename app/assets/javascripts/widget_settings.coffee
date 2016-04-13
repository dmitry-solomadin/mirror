window.WidgetSettings = ->

  showSettings: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "GET",
      url: $(btn).attr('href')
      success: (data) ->
        parsedData = $($.parseHTML(data))
        $('#modal').find(".modal-body").html(parsedData.filter('.modal-body').html())
        $('#modal').find(".modal-header").html(parsedData.filter('.modal-header').html())
        if $(btn).parents(".widget:first").data('widget-type') == "WEATHER"
          widgetSettings.initWeatherSettings()
        else if $(btn).parents(".widget:first").data('widget-type') == "COUNTDOWN"
          widgetSettings.initCountdownSettings()
        else if $(btn).parents(".widget:first").data('widget-type') == "DIRECTIONS"
          widgetSettings.initDirectionsSettings()
        $('.js-widget-settings-form').on 'ajax:success', (e, data, status, xhr) ->
          $('#modal').modal('hide')
        $('#modal').modal()

  initWeatherSettings: ->
    autocomplete = new google.maps.places.Autocomplete(
      $('.js-weather-location')[0], { types: ['(cities)'] })
    autocomplete.addListener 'place_changed', ->
      place = autocomplete.getPlace()
      $('.js-weather-location-name').val(place.address_components[0].long_name)
      $('.js-weather-location-lat').val(place.geometry.location.lat())
      $('.js-weather-location-lon').val(place.geometry.location.lng())

  initDirectionsSettings: ->
    autocompleteFrom = new google.maps.places.Autocomplete(
      $('.js-directions-from')[0], { })
    autocompleteFrom.addListener 'place_changed', ->
      place = autocompleteFrom.getPlace()
      $('.js-directions-from-short-name').val(place.name)

    autocompleteTo = new google.maps.places.Autocomplete(
      $('.js-directions-to')[0], { })
    autocompleteTo.addListener 'place_changed', ->
      place = autocompleteTo.getPlace()
      $('.js-directions-to-short-name').val(place.name)

  initCountdownSettings: ->
    $('.js-countdown-date-time').datetimepicker
      sideBySide: true

$(document).on 'ready page:load', ->
  window.widgetSettings = WidgetSettings()
