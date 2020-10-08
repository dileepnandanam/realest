class AddStiToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :type, :string
    add_column :properties, :brand, :string
    add_column :properties, :model, :string
  end
end
