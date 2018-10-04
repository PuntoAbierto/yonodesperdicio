ActiveAdmin.register Article do

  permit_params :title, :body, :video, :pin, :tag_list, :category, :published_at, :image

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
    column "Image" do |article|
      link_to image_tag(article.image.url(:thumb)), content_admin_article_path(article)
    end
    column "Title" do |article|
      link_to article.title, content_admin_article_path(article)
    end
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :category
  filter :body
  filter :pin
  filter :tags
  filter :published_at

  show do |article|
    attributes_table do
      row :id
      row :category
      row :slug
      row :title
      row :body
      row :image do
        article.image? ? image_tag(article.image.url, height: '100') : content_tag(:span, "No image yet")
      end
      row :video
      row :pin
      row :tag_list
      row :published_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :category, as: :select, collection: Article::CATEGORIES
      f.input :title
      f.input :body
      f.input :image, :as => :file, :hint => f.article.image_tag(f.object.image.url(:thumb))
      # Will preview the image when the object is edited
      f.input :video
      f.input :pin
      f.input :tag_list
      f.input :published_at
    end
    f.actions
  end
end
