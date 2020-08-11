class AddSeenToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :seen, :boolean, default: false
  end
end
