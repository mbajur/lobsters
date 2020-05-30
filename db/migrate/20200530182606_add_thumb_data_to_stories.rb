class AddThumbDataToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :thumb_data, :text
  end
end
