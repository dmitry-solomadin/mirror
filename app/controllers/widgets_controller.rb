class WidgetsController < ApplicationController

  before_action :authenticate!

  def create
    widget = Widget.create!(widget_params)
    if widget.parent.present?
      widget.parent.children << widget
      head :ok, content_type: 'text/html'
    else
      @dashboard = Dashboard.find(params[:dashboard_id])
      @dashboard.widgets << widget
      render partial: 'dashboard/row', locals: { widget: widget }
    end
  end

  def destroy
    Widget.find(params[:id]).destroy!
    head :ok, content_type: 'text/html'
  end

private

  def widget_params
    params.require(:widget).permit(:widget_type, :position, :parent_id)
  end

end