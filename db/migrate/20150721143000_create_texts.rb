class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :title
      t.text :body
      t.string :code
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
