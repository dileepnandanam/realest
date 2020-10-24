class AddDistrictToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :district, :string
  end
end
