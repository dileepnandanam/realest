class AddSuggestionToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :suggestion, :string
  end
end
