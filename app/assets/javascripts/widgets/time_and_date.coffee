$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="TIME_AND_DATE"]').each ->
    widget = @

    timeZone = $(widget).find('.js-time-zone').val()

    # TODO: get browser's utc offset
    window.displayDate = ->
      dateTime = if timeZone then moment().tz(timeZone).format('MMMM Do YYYY, h:mm:ss a') else moment().format('MMMM Do YYYY, h:mm:ss a')
      $(widget).find('.time-and-date').html(dateTime)
    displayDate()
    setInterval(displayDate, 1000)

    $(widget).find('.time-and-date-label').html($(widget).find(".js-time-zone-label").val())
