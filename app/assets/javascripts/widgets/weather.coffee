$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="WEATHER"]').each ->
    widget = @
    opts = {}

    lat = +$(widget).find('.js-location-lat').val()
    lon = +$(widget).find('.js-location-lon').val()
    name = $(widget).find('.js-location-name').val()

    # Setting default values to Boston
    lat = 42.3600825 if !lat
    lon ||= -71.05888010000001 if !lon
    name ||= "Boston" if !name

    opts.title = "<span class='pre'>Weather for </span>#{name}"

    if $('body').hasClass('inverted')
      opts.color = "#ffffff"
      opts.text_color = "#ffffff"

    if lat == null || lon == null
      opts.title = 'Invalid Location'

    unless ForecastEmbed.unit_labels[opts.units]
      opts.units = 'us'

    embed = new ForecastEmbed(opts)
    embed.elem.prependTo $(widget).find('.widget-content')
    embed.loading(true)

    url = "https://api.forecast.io/forecast/c0e979c69a540f095f458c396be299fc/#{lat},#{lon}?units=#{opts.units}"

    $.ajax
      url: url
      dataType: "jsonp"
      success: (data) ->
        embed.build(data)
        embed.loading(false)
