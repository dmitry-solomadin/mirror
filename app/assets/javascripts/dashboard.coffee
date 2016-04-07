window.Dashboard = ->

  init: ->
    dashboard.initSidepanel()
    dashboard.initWidgets()
    dashboard.initDragging()

  initDragging: ->
    @drake.destroy() if @drake
    elements = []
    $('.container, .js-side-panel').each -> elements.push @
    @drake = dragula elements,
      copy: (el, source) -> $(el).hasClass('sidepanel-widget')

    @drake.on 'drop', (el, target, source, sibling) ->
      if $(el).hasClass('sidepanel-widget')
        $(el).removeClass('sidepanel-widget')
        row = $(el).parent()
        $.ajax
          method: "POST",
          url: $(el).data('href')
          data:
            widget:
              widget_type: 'WEATHER',
              parent_id: row.data('row-id'),
              position: dashboard.widgetCount(row) + 1
          success: (data) ->
            $(el).replaceWith(data)
      else
        $.ajax
          method: "PATCH",
          url: $(el).data('href')
          data:
            widget:
              position: dashboard.widgetPositionInRow(el)
              parent_id: $(el).parents(".container:first").data('row-id')
          success: (data) ->
            $('.containers .last-row').before(data)
            dashboard.initDragging()

  initWidgets: ->
    # init rows
    $(".js-add-row-button").on 'click', (e) -> dashboard.addRow(@, e)
    $(".js-destroy-row-button").on 'click', (e) -> dashboard.destroyRow(@, e)

    # init widgets
    $(document).on 'click', ".js-add-widget-button", (e) -> dashboard.addWidget(@, e)
    $(document).on 'click', ".js-widget-settings-btn", (e) -> widgetSettings.showSettings(@, e)
    $(document).on 'click', ".js-widget-delete-btn", (e) -> dashboard.destroyWidget(@, e)
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
          position: dashboard.rowCount() + 1
      success: (data) ->
        $('.containers .last-row').before(data)
        dashboard.initDragging()

  destroyRow: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "DELETE",
      url: $(btn).attr('href')
      success: ->
        $(btn).parents(".container:first").remove()

  destroyWidget: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "DELETE",
      url: $(btn).attr('href')
      success: ->
        $(btn).parents(".widget:first").remove()

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
    direction = if $(handle).hasClass("js-left-widget-handle") then "left" else "right"
    $.ajax
      method: "POST",
      url: "#{$(handle).attr('href')}/unwrap"
      data:
        widget:
          move_direction: direction
          current_position: dashboard.widgetPositionInRow(widget) # TODO: should be current row position
      success: (data) ->
        prevOrNextRow.remove()
        widget.unwrap()
        dashboard.initDragging()

  wrap: (handle, widget) ->
    direction = if $(handle).hasClass("js-left-widget-handle") then "left" else "right"
    $.ajax
      method: "POST",
      url: "#{$(handle).attr('href')}/wrap"
      data:
        widget:
          move_direction: direction
          current_position: dashboard.widgetPositionInRow(widget)
      success: (data) ->
        if direction == 'right'
          widget.before('<div class="container-block col-md-6"></div>')
        else
          widget.after('<div class="container-block col-md-6"></div>')
        widget.wrap('<div class="container-block col-md-6"></div>')
        dashboard.initDragging()

  addWidget: (btn, e) ->
    e.preventDefault()
    row = $(btn).parents('.container:first')
    $.ajax
      method: "POST",
      url: $(btn).attr('href')
      data:
        widget:
          widget_type: 'WEATHER',
          parent_id: row.data('row-id'),
          position: dashboard.widgetCount(row) + 1
      success: (data) ->
        row.prepend(data)

  rowCount: -> $(".container-row").size()

  widgetCount: (row) -> row.find(".widget").size()

  widgetPositionInRow: (widget) -> $(widget).index(".widget")

$(document).on 'ready page:load', ->
  window.dashboard = Dashboard()
  dashboard.init()

