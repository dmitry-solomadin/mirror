window.Dashboard = ->

  init: ->
    $(".js-add-row-button").on 'click', -> dashboard.addRow()
    $(document).on 'click', ".js-add-widget-button", -> dashboard.addWidget(@)
    dashboard.initDragging()

  initDragging: ->
    elements = []
    $('.container-row').each ->
      elements.push @

    dragula(elements, {

    });

  addRow: ->
    $('.containers .last-row').before($('.sample-row').clone().removeClass('sample-row'))
    dashboard.initDragging()

  addWidget: (btn) ->
    container = $(btn).parents('.container-row:first')
    container.prepend($('.sample-widget').clone().removeClass('sample-widget'))
    container.find(".js-add-widget-button").remove()

$(document).on 'ready page:load', ->
  window.dashboard = Dashboard()
  dashboard.init()

