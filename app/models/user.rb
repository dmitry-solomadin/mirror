class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_one :dashboard

  before_create :add_dashboard

private

  def add_dashboard
    self.dashboard = Dashboard.create!
  end

end
