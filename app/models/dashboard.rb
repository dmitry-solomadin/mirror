class Dashboard < ActiveRecord::Base
  has_many :widgets
  belongs_to :user

  before_create :add_widget

private

  def add_widget
    widgets << Widget.create!(widget_type: 'ROW', position: 0)
  end

end
