$(document).on 'ready page:load', ->
  init = (widget) ->
    from = $(widget).find('.js-directions-from').val()
    to = $(widget).find('.js-directions-to').val()
    mode = eval($(widget).find('.js-directions-mode').val())

    return if !from || !to || !mode

    directionsService = new google.maps.DirectionsService()
    directionsRequest =
      origin: from
      destination: to
      travelMode: mode
      drivingOptions:
        departureTime: new Date()
        trafficModel: google.maps.TrafficModel.PESSIMISTIC
      unitSystem: google.maps.UnitSystem.METRIC
    directionsService.route(directionsRequest, (response, status) ->
      if status == google.maps.DirectionsStatus.OK
        $(widget).find('.directions-time').html(response.routes[0].legs[0].duration.text)
        # $("#summary").html(response.routes[0].summary)
        # $("#warnings").html(response.routes[0].warnings[0])
      else
        $(widget).find(".directions-wrapper").html("Unable to retrieve your route.")
    )

  $('.widget[data-widget-type="DIRECTIONS"]').each ->
    widget = @
    init widget
    setInterval (-> init widget), widgets.AUTOUPDATE_INTERVAL
