class WidgetsController < ApplicationController

  before_action :authenticate!

  def create
    @dashboard = Dashboard.find(params[:dashboard_id])
    widget = Widget.create!(widget_params)
    if widget.parent.present?
      widget.parent.children << widget
      render partial: 'dashboard/widget', locals: { widget: widget }
    else
      @dashboard.widgets << widget
      render partial: 'dashboard/row', locals: { widget: widget }
    end
  end

  def update
    widget = Widget.find(params[:id])
    current_parent = widget.parent
    current_parent.children.delete(widget)
    new_row_1 = Widget.create!(widget_type: "ROW", position: widget_update_params[:current_position],
                               parent_id: current_parent.id)
    new_row_2 = Widget.create!(widget_type: "ROW", position: widget_update_params[:current_position],
                               parent_id: current_parent.id)
    current_parent.children << new_row_1
    current_parent.children << new_row_2
    if widget_update_params[:move_direction] == 'left'
      new_row_1.children << widget
    else
      new_row_2.children << widget
    end
    head :ok, content_type: 'text/html'
  end

  def destroy
    Widget.find(params[:id]).destroy!
    head :ok, content_type: 'text/html'
  end

private

  def widget_params
    params.require(:widget).permit(:widget_type, :position, :parent_id)
  end

  def widget_update_params
    params.require(:widget).permit(:move_direction, :current_position)
  end

end