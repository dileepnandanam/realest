class AddTagsToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :tags, :text
  end
end
