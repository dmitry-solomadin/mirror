$(document).on 'ready page:load', ->
  $('.widget[data-widget-type="NY_TIMES"]').each ->
    widget = @

    limit = $(widget).find('.js-ny-times-limit').val() || 10
    category = $(widget).find('.js-ny-times-category').val() || 'business'

    api_key = "26e35bee8b12a36a93e2e420e46aba0a:15:74962616"
    api_url = "http://api.nytimes.com/svc/news/v3/content/all/#{category}/72.json?limit=#{limit}&api-key=#{api_key}"

    $.ajax
      url: api_url
      method: 'GET'
      success: (data) ->
        $(data.results).each ->
          $(widget).find(".widget-content").append(
            "<div class='ny-times-news-piece'><div class='ny-times-news-headline'>#{@.title}</div>" +
            "<div class='ny-times-news-abstract'>#{@.abstract}</div></div>")
