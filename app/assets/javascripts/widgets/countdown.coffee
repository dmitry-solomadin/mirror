$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="COUNTDOWN"]').each ->
    widget = @

    eventDate = $(widget).find('.js-countdown-date-time').val()

    window.displayDate = ->
      dateTimeDiff = moment.duration(moment().diff(moment(eventDate,"MM/DD/YYYY h:mm a")))
      absHours = Math.abs(dateTimeDiff.asHours())
      days = parseInt(absHours / 24)
      diff = "#{days}d #{Math.round(absHours - (days * 24))}h"
      $(widget).find('.countdown-date-time').html(diff)

    displayDate()
    setInterval(displayDate, 1000 * 60)

    $(widget).find('.countdown-label').html($(widget).find(".js-countdown-label").val())
