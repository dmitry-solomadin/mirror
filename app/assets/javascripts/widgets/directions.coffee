$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="DIRECTIONS"]').each ->
    widget = @

    from = $(widget).find('.js-directions-from').val()
    to = $(widget).find('.js-directions-to').val()

    directionsService = new google.maps.DirectionsService()
    directionsRequest =
      origin: from
      destination: to
      travelMode: google.maps.DirectionsTravelMode.DRIVING
      unitSystem: google.maps.UnitSystem.METRIC
    directionsService.route(directionsRequest, (response, status) ->
      if status == google.maps.DirectionsStatus.OK
        $(widget).find('.directions-time').html(response.routes[0].legs[0].duration.text)
        #$("#summary").html(response.routes[0].summary)
        #$("#warnings").html(response.routes[0].warnings[0])
      else
        $(widget).find(".directions-wrapper").html("Unable to retrieve your route.")
    )

