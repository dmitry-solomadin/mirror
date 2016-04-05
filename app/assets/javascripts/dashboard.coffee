window.Dashboard = ->

  init: ->
    dashboard.initSidepanel()
    dashboard.initWidgets()
    dashboard.initDragging()

  initDragging: ->
    @drake.destroy() if @drake
    elements = []
    $('.container-row, .container-block').each -> elements.push @
    @drake = dragula elements

  initWidgets: ->
    # init rows
    $(".js-add-row-button").on 'click', (e) -> dashboard.addRow(@, e)
    $(".js-destroy-row-button").on 'click', (e) -> dashboard.destroyWidget(@, e)

    # init widgets
    $(document).on 'click', ".js-add-widget-button", (e) -> dashboard.addWidget(@, e)
    $(document).on 'click', ".js-left-widget-handle, .js-right-widget-handle", (e) -> dashboard.moveWidget(@, e)

  initSidepanel: ->
    $('.js-side-btn').on 'click', ->
      if $('.js-side-panel').css("left") == "-300px"
        $('.js-side-panel').css("left": "0")
        $('.js-side-btn').css("left": "269px")
      else
        $('.js-side-panel').css("left": "-300px")
        $('.js-side-btn').css("left": "-31px")

  addRow: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "POST",
      url: $(btn).attr('href')
      data:
        widget:
          widget_type: 'ROW',
          position: dashboard.maxRowPosition() + 1
      success: (data) ->
        $('.containers .last-row').before(data)
        dashboard.initDragging()

  destroyWidget: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "DELETE",
      url: $(btn).attr('href')
      success: ->
        $(btn).parents(".container-row:first").remove()

  moveWidget: (handle, e) ->
    e.preventDefault()
    widget = $(handle).parents('.widget:first')
    direction = if $(handle).hasClass("js-left-widget-handle") then "left" else "right"
    row = widget.parent()

    if row.hasClass('container-block')
      parentPrev = row.prev()
      parentNext = row.next()

      # remove container
      if direction == 'left' and parentPrev.hasClass('container-block') and parentPrev.offset().top == row.offset().top
        dashboard.unwrap(handle, widget, parentPrev)
        return
      else if direction == 'right' and parentNext.hasClass('container-block') and parentNext.offset().top == row.offset().top
        dashboard.unwrap(handle, widget, parentNext)
        return

    # add container
    dashboard.wrap(handle, widget)

  unwrap: (handle, widget, prevOrNextRow) ->
    row = widget.parent()
    direction = if $(handle).hasClass("js-left-widget-handle") then "left" else "right"
    $.ajax
      method: "POST",
      url: "#{$(handle).attr('href')}/unwrap"
      data:
        widget:
          move_direction: direction
          current_position: dashboard.maxWidgetPositionInRow(row) # TODO: should be current row position
      success: (data) ->
        prevOrNextRow.remove()
        widget.unwrap()
        dashboard.initDragging()

  wrap: (handle, widget) ->
    row = widget.parent()
    direction = if $(handle).hasClass("js-left-widget-handle") then "left" else "right"
    $.ajax
      method: "POST",
      url: "#{$(handle).attr('href')}/wrap"
      data:
        widget:
          move_direction: direction
          current_position: dashboard.maxWidgetPositionInRow(row)
      success: (data) ->
        if direction == 'right'
          widget.before('<div class="container-block col-md-6"></div>')
        else
          widget.after('<div class="container-block col-md-6"></div>')
        widget.wrap('<div class="container-block col-md-6"></div>')
        dashboard.initDragging()

  addWidget: (btn, e) ->
    e.preventDefault()
    row = $(btn).parents('.container-row:first')
    $.ajax
      method: "POST",
      url: $(btn).attr('href')
      data:
        widget:
          widget_type: 'WEATHER',
          parent_id: row.data('row-id'),
          position: dashboard.maxWidgetPositionInRow(row) + 1
      success: (data) ->
        row.prepend(data)
        row.find(".js-add-widget-button").remove()

  maxRowPosition: -> $(".container-row").size()

  maxWidgetPositionInRow: (row) -> row.find(".widget").size()

$(document).on 'ready page:load', ->
  window.dashboard = Dashboard()
  dashboard.init()

