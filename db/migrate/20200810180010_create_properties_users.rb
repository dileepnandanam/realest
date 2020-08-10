class CreatePropertiesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :properties_users do |t|
      t.integer :property_id
      t.integer :user_id

      t.timestamps
    end
  end
end
