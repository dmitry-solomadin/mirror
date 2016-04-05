class Widget < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :parent, foreign_key: :parent_id, class_name: :Widget, dependent: :delete
  has_many :children, foreign_key: :parent_id, class_name: :Widget

  validates_presence_of :widget_type, :position
  validates_inclusion_of :widget_type, in: %w(ROW WEATHER)
end
