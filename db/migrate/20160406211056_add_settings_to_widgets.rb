class AddSettingsToWidgets < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    add_column :widgets, :settings, :hstore
    add_index :widgets, :settings, using: :gin
  end
end
