class DashboardController < ApplicationController

  before_action :authenticate!

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def add_widget
    dashboard = Dashboard.find(params[:id])
    dashboard.widgets <<
      Widget.create!(widget_type: add_widget_params[:widget_type], position: add_widget_params[:position])
    head :ok, content_type: 'text/html'
  end

private

  def add_widget_params
    params.permit(:dashboard_id, :widget_type, :position)
  end

end