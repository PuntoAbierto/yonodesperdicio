class ChangeComments < ActiveRecord::Migration
  def change
    drop_table :commentsAdCount
    drop_table :comments

    create_table :comments do |t|
      t.string :commentable_type
      t.integer :commentable_id
      t.integer :user_id
      t.text :body

      t.timestamps null: false
    end
  end
end
