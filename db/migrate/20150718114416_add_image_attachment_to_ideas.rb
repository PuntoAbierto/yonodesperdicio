class AddImageAttachmentToIdeas < ActiveRecord::Migration
  def self.up
    change_table :ideas do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :ideas, :image
  end
end
