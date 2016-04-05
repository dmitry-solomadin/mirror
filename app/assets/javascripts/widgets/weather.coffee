$(document).on 'ready page:load', ->
  opts = {}
  param_strs = "#lat=30.25&lon=-97.75&name=Austin, TX".substr(1).split('&')
  params = {}

  for param in param_strs
    param_str = param.split('=')
    if !param_str || param_str.length != 2
      continue

    key = $.trim(param_str[0]).toLowerCase()
    val = decodeURIComponent($.trim(param_str[1]))

    if key == 'lat' || key == 'latitude'
      lat = +val
    else if key == 'lon' || key == 'longitude'
      lon = +val
    else if key == 'name'
      name = val
    else if key == 'color'
      opts.color = val
    else if key == 'text-color'
      opts.text_color = val
    else if key == 'font'
      opts.font = val
    else if key == 'font-face-name'
      opts.ff_name = val
    else if key == 'font-face-url'
      opts.ff_url = val
    else if key == 'units'
      opts.units = val.toLowerCase()
    else if key == 'static-skycons'
      opts.static_skycons = true
    else if key == 'hide-header'
      opts.hide_header = true

  if name
    opts.title = '<span class="pre">Weather for </span>' + name
  else
    opts.title = 'Weather'

  if lat == null || lon == null
    opts.title = 'Invalid Location'

  unless ForecastEmbed.unit_labels[opts.units]
    opts.units = 'us'

  embed = new ForecastEmbed(opts)
  embed.elem.prependTo($('.widget[data-widget-type="WEATHER"] .widget-content'))
  embed.loading(true)

  url = "https://api.forecast.io/forecast/c0e979c69a540f095f458c396be299fc/#{lat},#{lon}?callback=?&units=#{opts.units}"
  forecast_request = $.getJSON(url, (f) ->
    embed.build(f)
    embed.loading(false)
  )
