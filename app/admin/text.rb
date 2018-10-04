ActiveAdmin.register Text do

  permit_params :title, :body, :code, :published_at

  index do
    selectable_column
    column :code
    column :title
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  show do |text|
    attributes_table do
      row :code
      row :title
      row :body
      row :published_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :code
      f.input :title
      f.input :body
      f.input :published_at
    end
    f.actions
  end
end
