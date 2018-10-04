class AddFieldsToIdeas < ActiveRecord::Migration

  def self.up
    add_column :ideas, :introduction, :text
    add_column :ideas, :ingredients, :text
  end

end
