class AddFieldsToArticles < ActiveRecord::Migration

  def self.up
    add_column :articles, :video, :text
  end

end
