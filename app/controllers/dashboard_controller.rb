class DashboardController < ApplicationController

  before_action :authenticate!

  def show
    @dashboard = Dashboard.find(params[:id])
  end

end