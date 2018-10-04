class AddSlugs < ActiveRecord::Migration
  def change
    add_column :articles, :slug, :string, unique: true
    add_column :ideas, :slug, :string, unique: true
    add_column :organizations, :slug, :string, unique: true
  end
end
