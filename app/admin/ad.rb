ActiveAdmin.register Ad do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :status, :title, :user, :user_id, :body,
                :grams, :expiration_date, :pick_up_date,
                :image, :food_category, :zipcode, :city
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

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
    id_column
    column :status_string
    column :user
    column :food_category
    column "Image" do |ad|
      link_to image_tag(ad.image.url(:thumb)), content_admin_ad_path(ad)
    end
    column :title
    column :grams
    column :pick_up_date
    #column :expiration_date
    actions
  end

  filter :status
  filter :user
  filter :food_category
  filter :pick_up_date
  filter :created_at
  filter :zipcode

  show do |ad|
    attributes_table do
      row :status_string
      row :user
      row :zipcode
      row :food_category
      row :title
      row :body
      row :pick_up_date
      #row :expiration_date
      row :grams
      row :image do
        ad.image? ? image_tag(ad.image.url, height: '100') : content_tag(:span, "No image yet")
      end
      row :created_at
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      #f.input :status, :as => :select, collection: Ad.all.status_string, include_blank: false
      #f.input :user_id
      f.input :user, :as => :select, :user_id => :username      
      f.input :zipcode
      f.input :status, :as => :select, collection: {"disponible" => 1, "reservado" => 2 , "entregado" => 3}
      f.input :food_category, :as => :select, collection: Ad::FOOD_CATEGORIES
      f.input :title
      f.input :body
      f.input :grams
      f.input :pick_up_date
      #f.input :expiration_date
      f.input :image, :as => :file, :hint => f.article.image_tag(f.object.image.url(:thumb))
      f.input :created_at
    end
    f.actions
  end
end
