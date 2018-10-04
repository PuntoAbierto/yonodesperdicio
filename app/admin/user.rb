ActiveAdmin.register User do
  permit_params :username, :name, :email, :city, 
                :province, :zipcode, :image, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column "Image" do |user|
      link_to image_tag(user.image.url(:thumb)), content_admin_user_path(user)
    end
    column :username
    column :name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :accept_mailing
    actions
  end

  show do |user|
    attributes_table do
      row :username
      row :name
      row :email
      row :city
      row :province      
      row :zipcode
      row :image do
        user.image? ? image_tag(user.image.url, height: '100') : content_tag(:span, "No image yet")
      end
      row :created_at
      row :accept_mailing
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :username
      f.input :name      
      f.input :email
      f.input :city
      f.input :province
      f.input :zipcode      
      f.input :password
      f.input :password_confirmation
      f.input :image, :as => :file, :hint => f.article.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end
end
