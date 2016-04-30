class AddVersionToDashboard < ActiveRecord::Migration
  def change
    add_column :dashboards, :version, :integer
  end
end
