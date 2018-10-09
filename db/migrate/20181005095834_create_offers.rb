class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.datetime :published_at
      t.attachment :image
      t.integer :status, default: 0
      t.string :address
      t.string :store
      t.datetime :until
      t.references :user

      t.timestamps null: false
    end
  end
end
