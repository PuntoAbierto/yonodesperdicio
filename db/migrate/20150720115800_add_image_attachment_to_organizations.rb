class AddImageAttachmentToOrganizations < ActiveRecord::Migration
  def self.up
    change_table :organizations do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :organizations, :image
  end
end
