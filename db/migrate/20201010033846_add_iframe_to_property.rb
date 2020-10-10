class AddIframeToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :iframe, :text
  end
end
