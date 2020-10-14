class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.string :contact
      t.string :about

      t.timestamps
    end
  end
end
