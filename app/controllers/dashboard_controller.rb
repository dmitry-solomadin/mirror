class DashboardController < ApplicationController

  before_action :authenticate!

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def preview
    @dashboard = Dashboard.find(params[:id])
    @mode = params[:mode]
    render 'preview', layout: 'preview'
  end

  def show_add_widget
    @dashboard = Dashboard.find(params[:id])
    @row = Widget.find(params[:row_id])
    render 'add_widget', layout: false
  end

end
