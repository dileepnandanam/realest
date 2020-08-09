class AddLandMassToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :land_mass, :float
  end
end
