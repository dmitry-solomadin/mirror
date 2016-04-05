class Widget < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :parent, foreign_key: :parent_id, class_name: :Widget
  has_many :children, foreign_key: :parent_id, class_name: :Widget

  validates_presence_of :widget_type, :position
  validates_inclusion_of :widget_type, in: %w(ROW WEATHER)

  def self.by_position
    order(position: :asc)
  end

  def insert_new_row(position)
    children.where('position >= ?', position).each do |child|
      child.update(position: child.position + 1)
    end
    Widget.create!(widget_type: "ROW", position: position, parent_id: id)
  end

  def top?
    parent_id.nil?
  end
end
