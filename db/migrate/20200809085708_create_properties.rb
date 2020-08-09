class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.integer :user_id
      t.float :lat
      t.float :lngt
      t.string :state
      t.bigint :expected_price
      t.integer :acre
      t.integer :cent
      t.text :landmark

      t.timestamps
    end
  end
end
