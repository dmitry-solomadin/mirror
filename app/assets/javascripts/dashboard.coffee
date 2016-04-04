window.Dashboard = ->

  init: ->
    $(".js-add-row-button").on 'click', -> dashboard.addRow()
    dashboard.initSidepanel()
    dashboard.initWidgets()
    dashboard.initDragging()

  initDragging: ->
    @drake.destroy() if @drake
    elements = []
    $('.container-row, .container-block').each -> elements.push @
    @drake = dragula elements

  initWidgets: ->
    $(document).on 'click', ".js-add-widget-button", -> dashboard.addWidget(@)
    $(document).on 'click', ".js-left-widget-handle", -> dashboard.moveWidgetLeft(@)
    $(document).on 'click', ".js-right-widget-handle", -> dashboard.moveWidgetRight(@)

  initSidepanel: ->
    $('.js-side-btn').on 'click', ->
      if $('.js-side-panel').css("left") == "-300px"
        $('.js-side-panel').css("left": "0")
        $('.js-side-btn').css("left": "269px")
      else
        $('.js-side-panel').css("left": "-300px")
        $('.js-side-btn').css("left": "-31px")

  moveWidget: (handle, direction) ->
    widget = $(handle).parents('.widget:first')
    widgetParent = widget.parent()

    if widgetParent.hasClass('container-block')
      parentPrev = widgetParent.prev()
      parentNext = widgetParent.next()

      # remove container
      if direction == 'left' and parentPrev.hasClass('container-block') and parentPrev.offset().top == widgetParent.offset().top
        parentPrev.remove()
        widget.unwrap()
        dashboard.initDragging()
        return
      else if direction == 'right' and parentNext.hasClass('container-block') and parentNext.offset().top == widgetParent.offset().top
        parentNext.remove()
        widget.unwrap()
        dashboard.initDragging()
        return

    # add container
    if direction == 'right'
      widget.before('<div class="container-block col-md-6"></div>')
    else
      widget.after('<div class="container-block col-md-6"></div>')
    widget.wrap('<div class="container-block col-md-6"></div>')
    dashboard.initDragging()

  moveWidgetRight: (handle) -> dashboard.moveWidget(handle, 'right')

  moveWidgetLeft: (handle) -> dashboard.moveWidget(handle, 'left')

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

