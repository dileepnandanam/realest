class AddVisibleCaptionToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :visible_caption, :string
  end
end
