class CreatePropertyAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :property_assets do |t|
      t.text :iframe
      t.integer :property_id

      t.timestamps
    end
  end
end
