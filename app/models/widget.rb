class Widget < ActiveRecord::Base
  WIDGET_TYPES = %w(ROW WEATHER TIME_AND_DATE COUNTDOWN QUOTE)

  belongs_to :dashboard
  belongs_to :parent, foreign_key: :parent_id, class_name: :Widget
  has_many :children, foreign_key: :parent_id, class_name: :Widget

  validates_presence_of :widget_type, :position
  validates_inclusion_of :widget_type, in: WIDGET_TYPES

  after_initialize do |widget|
    widget.settings = {} if widget.new_record?
  end

  store_accessor :settings,
                 :location_full_name, :location_lat, :location_lon, :location_name, # WEATHER
                 :time_zone, :time_zone_label # TIME AND DATE

  def self.by_position
    order(position: :asc)
  end

  def self.all_types
    WIDGET_TYPES
  end

  def self.widget_types
    WIDGET_TYPES.reject { |wt| wt == "ROW" }
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
