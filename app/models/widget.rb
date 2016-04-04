class Widget < ActiveRecord::Base
  belongs_to :dashboard

  validates_presence_of :widget_type, :position
  validates_inclusion_of :widget_type, in: %w(ROW)
end
