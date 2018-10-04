class AddImageAttachmentToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :articles, :image
  end
end
