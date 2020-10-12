class AddIndexToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :index, :text
  end
end
