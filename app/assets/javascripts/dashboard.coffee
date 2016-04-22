window.Dashboard = ->

  init: ->
    dashboard.initSidepanel()
    dashboard.initWidgets()
    dashboard.initDragging()

  initDragging: ->
    @drake.destroy() if @drake
    elements = []
    $('.widget-container, .js-side-panel').each -> elements.push @
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
              widget_type: $(el).data('widget-type'),
              parent_id: row.data('row-id'),
              position: dashboard.widgetCount(row) + 1 # TODO: Bug - always assigns last position
          success: (data) ->
            $(el).replaceWith(data)
      else
        newPosition = if $(el).next().hasClass('widget')
          $(el).next().data('widget-position')
        else
          $(el).prev().data('widget-position') + 1
        $.ajax
          method: "PATCH",
          url: $(el).data('href') + "/update_position"
          data:
            widget:
              position: newPosition
              parent_id: $(el).parents(".widget-container:first").data('row-id')
          success: (data) ->
            $('.containers .last-row').before(data)
            dashboard.initDragging()

  initWidgets: ->
    # init rows
    $(".js-add-row-button").on 'click', (e) -> dashboard.addRow(@, e)
    $(document).on 'click', ".js-destroy-row-button", (e) -> dashboard.destroyRow(@, e)

    $(".container-block").filter((index, element) ->
      (index + 1) % 2 == 0;
    ).addClass("second")

    # init widgets
    $(document).on 'click', ".js-add-widget-button", (e) -> dashboard.showAddWidget(@, e)
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
        $(btn).parents(".widget-container:first").remove()

  showAddWidget: (btn, e) ->
    e.preventDefault()
    $.ajax
      method: "GET",
      url: $(btn).attr('href')
      success: (data) ->
        parsedData = $($.parseHTML(data))
        $('#modal').find(".modal-body").html(parsedData.filter('.modal-body').html())
        $('#modal').find(".modal-header").html(parsedData.filter('.modal-header').html())
        $('.js-add-widget-row').on 'click', (e, data, status, xhr) ->
          dashboard.addWidget(@, e)
          $('#modal').modal('hide')
        $('#modal').modal()

  addWidget: (btn, e) ->
    e.preventDefault()
    rowId = $(btn).data('row-id')
    row = dashboard.rowById(rowId)
    $.ajax
      method: "POST",
      url: $(btn).data('href')
      data:
        widget:
          widget_type: $(btn).data('widget-type')
          parent_id: rowId,
          position: dashboard.maxPositionInRow(row) + 1
      success: (data) ->
        $(data).insertBefore(row.find('.js-destroy-row-button'))

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
        widget.parents('.widget-container:first').replaceWith(data)
        dashboard.initDragging()

  rowById: (rowId) -> $(".widget-container[data-row-id=#{rowId}]")

  rowCount: -> $(".container-row").size()

  widgetCount: (row) -> row.find(".widget").size()

  maxPositionInRow: (row) ->
    maxPosition = -1
    $(row).find(".widget").each ->
      maxPosition = $(@).data('widget-position') if maxPosition < $(@).data('widget-position')
    maxPosition

  widgetPositionInRow: (widget) -> $(widget).data("widget-position")

$(document).on 'ready page:load', ->
  window.dashboard = Dashboard()
  dashboard.init()

