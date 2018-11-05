# frozen_string_literal: true

ActiveAdmin.register Offer do
  permit_params :title, :description, :status, :address, :store, :until


  controller do
    defaults :finder => :find_by_slug
  end

  index do
    selectable_column
    id_column
    column :status
    column :title
    column("Image") { |offer| link_to image_tag(offer.image.url(:thumb)), content_admin_offer_path(offer) }
    column :description
    column :store
    column :address
    column :until
    column :user
    actions
  end

  filter :status, as: :select, collection: Offer.statuses
  filter :user
  filter :until
  filter :store


  form do |f|
    f.inputs "Admin Details" do
      f.input :user, as: :select, user_id: :username      
      f.input :status, as: :select, collection: Offer.statuses.keys
      f.input :title
      f.input :description
      f.input :store
      f.input :address
      f.input :until
      f.input :image, as: :file
    end
    f.actions
  end
end
