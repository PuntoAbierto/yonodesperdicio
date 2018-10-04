ActiveAdmin.register Idea do

  permit_params :title, :introduction, :ingredients, :body, 
                :category, :tag_list, :published_at, :user_id, :image
  
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
    column :category
    column "Image" do |idea|
      link_to image_tag(idea.image.url(:thumb)), content_admin_idea_path(idea)
    end
    column "Title" do |idea|
      link_to idea.title, content_admin_idea_path(idea)
    end
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  filter :user
  filter :tags
  filter :category
  filter :ingredients
  filter :body

  show do |idea|
    attributes_table do
      row :id
      row :slug
      row :user
      row :category
      row :title
      row :introduction
      row :ingredients
      row :body
      row :image do
        idea.image? ? image_tag(idea.image.url, height: '100') : content_tag(:span, "No image yet")
      end
      row :tag_list
      row :published_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :category, as: :select, collection: Idea::CATEGORIES
      f.input :title
      f.input :introduction
      f.input :ingredients
      f.input :body
      f.input :tag_list
      f.input :image, :as => :file, :hint => f.article.image_tag(f.object.image.url(:thumb))
      # Will preview the image when the object is edited
      f.input :published_at
    end
    f.actions
  end
end
