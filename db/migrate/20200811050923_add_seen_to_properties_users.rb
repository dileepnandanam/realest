class AddSeenToPropertiesUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :properties_users, :seen, :boolean, dafault: false
  end
end
