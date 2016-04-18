$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="TIME_AND_DATE"]').each ->
    widget = @

    # TODO: get browser's utc offset
    timeZone = $(widget).find('.js-time-zone').val()

    window.displayDate = ->
      dateTime = if timeZone then moment().tz(timeZone).format('MMMM Do YYYY, h:mm a') else moment().format('MMMM Do YYYY, h:mm a')
      $(widget).find('.time-and-date').html(dateTime)
    displayDate()
    setInterval(displayDate, 1000)

    $(widget).find('.time-and-date-label').html($(widget).find(".js-time-zone-label").val())
