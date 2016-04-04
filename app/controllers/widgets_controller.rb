class WidgetsController < ApplicationController

  before_action :authenticate!

  # TODO: should actually return template
  def create
    dashboard = Dashboard.find(params[:dashboard_id])
    dashboard.widgets <<
      Widget.create!(widget_type: widget_params[:widget_type], position: widget_params[:position])
    head :ok, content_type: 'text/html'
  end

  def destroy
    Widget.find(params[:id]).destroy!
    head :ok, content_type: 'text/html'
  end

private

  def widget_params
    params.require(:widget).permit(:widget_type, :position)
  end

end