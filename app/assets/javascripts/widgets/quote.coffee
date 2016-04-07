$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="QUOTE"]').each ->
    widget = @
    quoteAPIUrl = 'http://quotes.rest/quote.json?api_key=5WvOasgy8NElPBz3D7NO9geF&category=sports&maxlength=200'
    $.ajax
      url: quoteAPIUrl
      success: (data) ->
        console.log(data)
        $(widget).find('.js-quote-text').html data.contents.quote
        $(widget).find('.js-quote-author').text "-#{data.contents.author}"
