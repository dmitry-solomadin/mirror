class DashboardController < ApplicationController

  before_action :authenticate!

  def show
    @dashboard = Dashboard.find(params[:id])
    respond_to do |f|
      f.html
      f.json { render json: { version: @dashboard.version }.to_json }
    end
  end

  def increase_version
    @dashboard = Dashboard.find(params[:id])
    version = @dashboard.version || 0
    @dashboard.update(version: version + 1)
    redirect_to @dashboard
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

private

  def widget_params
    params.require(:dashboard).permit(:version)
  end

end
