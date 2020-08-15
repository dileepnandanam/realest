class AddPlaceToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :place, :string
  end
end
