ActiveAdmin.register Organization do
  permit_params :name, :description, :zipcode, :address, :phone, :email, :website, :image

  controller do
    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
  end

  index do
    selectable_column
    column :id
    column "Title" do |organization|
      link_to organization.name, content_admin_organization_path(organization)
    end
    column :address
    column :zipcode
    column :email
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :zipcode
  filter :address
  filter :email
  filter :phone
  filter :website

  show do |organization|
    attributes_table do
      row :id
      row :slug
      row :name
      row :description
      row :address
      row :zipcode
      row :phone
      row :email
      row :website
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :address
      f.input :zipcode
      f.input :phone
      f.input :email
      f.input :website
    end
    f.actions
  end

end
