class AddTotalCentsToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :total_cents, :bigint
  end
end
