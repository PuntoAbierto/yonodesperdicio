class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :body
      t.string :category
      t.datetime :published_at
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
