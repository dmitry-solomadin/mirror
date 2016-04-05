class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :dashboard_id
      t.integer :parent_id
      t.string :widget_type
      t.integer :position

      t.timestamps null: false
    end
  end
end
