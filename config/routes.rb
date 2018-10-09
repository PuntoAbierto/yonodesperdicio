require 'sidekiq/web'

Yonodesperdicio::Application.routes.draw do

  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticated :admin_user do
    mount Sidekiq::Web, at: "/sidekiq"
  end

  root 'home#index'

  get '/noticias/(:tag)', to: 'home#noticias', as: 'noticias'
  get '/noticia/:id', to: 'home#noticia', as: 'noticia'
  post '/noticia/:id/comments', to: 'comments#create', as: 'noticia_comments', commentable_type: 'Article', article_category: 'noticia'

  get '/iniciativas_sociales/(:tag)', to: 'home#iniciativas_sociales', as: 'iniciativas_sociales'
  get '/iniciativa_social/:id', to: 'home#iniciativa', as: 'iniciativa'
  post '/iniciativa_social/:id/comments', to: 'comments#create', as: 'iniciativa_comments', commentable_type: 'Article', article_category: 'iniciativa'

  get '/ideas/(:category)', to: 'home#ideas', as: 'ideas'
  get '/ideas/de/:tag', to: 'home#ideas_tag', as: 'ideas_tag'
  get '/idea/:id', to: 'home#idea', as: 'idea'
  post '/idea/:id/comments', to: 'comments#create', as: 'idea_comments', commentable_type: 'Idea'

  get '/organizaciones', to: 'home#organizations', as: 'organizations'
  get '/organizacion/:id', to: 'home#organization', as: 'organization'

  get '/particulares', to: 'home#particulares', as: 'particulares'

  scope '/page' do
    get '/funciona', to: 'page#funciona', as: 'funciona'
    get '/faqs', to: 'page#faqs', as: 'faqs'
    get '/legal', to: 'page#legal', as: 'legal'
    get '/tos', to: 'page#tos', as: 'tos'
    get '/about', to: 'page#about', as: 'about'
    get '/privacy', to: 'page#privacy', as: 'privacy'
    get '/translate', to: 'page#translate', as: 'translate'
    get '/sitemap', to: 'page#sitemap', as: 'sitemap'
  end

  namespace :api, defaults: { format: :json } do
    get 'total_kg', to: 'base#total_kg'
    get 'categories', to: 'base#categories'
    get '', to: 'base#index'
    resources :users, :only => [:show, :create, :update, :destroy] do
      post 'rate', on: :member
    end
    resources :sessions, :only => [:create, :destroy]
    resources :ideas do
      resources :comments, :only => [:create]
    end
    resources :ads do
      resources :comments, :only => [:create]
    end
    resources :offers
    resources :mailboxes, :only => [:show] do
      resources :conversations, :only => [:index, :show] do
        resources :messages, :only => [:index, :create]
      end
    end
    post '/new_message/(:recipient_id)', to: 'messages#new_message'
  end

  resources :ideas, path: 'mis_ideas', as: 'my_ideas'

  # FIXME: type on ads#create instead of params
  # FIXME: nolotirov2 legacy - redirect from /es/ad/create
  resources :ads, path: 'ad', path_names: { new: 'create' }

  scope '/ad' do
    #get '/create', to: redirect('/ad/create/type/1')
    get '/:id/:slug', to: 'ads#show', :as => 'adslug'
    get '/edit/id/:id', to: 'ads#edit', :as => 'ads_edit'
    get '/listall/ad_type/:type', to: 'woeid#show', as: "ads_listall"
    get '/listall/ad_type/:type/status/:status', to: 'woeid#show', as: 'ads_listall_status'
    get '/listall/page/:page/ad_type/:type', to: redirect('/ad/listall/ad_type/%{type}?page=%{page}')
    get '/listuser/id/:id', to: 'users#listads', as: 'listads_user'
  end

  resources :offers

  # locations lists
  get '/woeid/:id/:type', to: 'woeid#show', as: 'ads_woeid'
  get '/woeid/:id/:type/page/:page', to: redirect('/woeid/%{id}/%{type}?page=%{page}')
  get '/woeid/:id/:type/status/:status', to: 'woeid#show', as: 'ads_woeid_status'
  get '/woeid/:id/:type/page/:page/status/:status', to: redirect('/woeid/%{id}/%{type}/status/%{status}?page=%{page}')

  # location change
  scope '/location' do
    get  '/change', to: 'location#ask', as: 'location_ask'
    get  '/change2', to: 'location#change', as: 'location_change'
    post '/change', to: 'location#list'
    post '/change2', to: 'location#change'
  end

  # auth
  get '/auth/login', to: redirect('/es/user/login')
  get '/user/forgot', to: redirect('/es/user/reset/new')

  devise_for :users,
    :controllers => { :registrations => 'registrations' },
    path: 'user',
    path_names: {
      sign_up: 'register',
      sign_in: 'login',
      sign_out: 'logout',
      password: 'reset'
  }

  post '/addfriend/id/:id', to: 'friendships#create', as: 'add_friend'
  post '/deletefriend/:id', to: 'friendships#destroy', as: 'destroy_friend'

  scope '/admin' do
    get '/become/:id', to: 'admin#become', as: 'become_user'
    get '/lock/:id', to: 'admin#lock', as: 'lock_user'
    get '/unlock/:id', to: 'admin#unlock', as: 'unlock_user'
  end

  get '/user/edit/id/:id', to: redirect('/user/edit'), as: 'user_edit'
  get '/profile/:username', to: 'users#profile', as: 'profile'

  # comments
  post '/ad/:id/comments', to: 'comments#create', as: 'create_comment', commentable_type: 'Ad'

  # search
  get '/search', to: 'search#search', as: 'search'

  # messaging
  resources :mailboxer_messages, controller: :messages, path: "/messages/" do
    member do
      delete 'trash'
      post 'untrash'
    end
    collection do
      delete 'trash'
    end
  end

  post 'messages/search', to: 'messages#search', as: "search_mailboxer_messages"

  # messaging legacy
  scope '/message' do
    get  '/received', to: redirect('/es/message/list'), as: 'messages_received'
    get  '/list', to: 'messages#index', as: 'messages_list'
    get  '/show/:id/subject/:subject', to: 'messages#show', as: 'message_show'
    get  '/create/id_user_to/:user_id', to: 'messages#new', as: 'message_new'
    get  '/create/id_user_to/:user_id/subject/:subject', to: "messages#new", as: 'message_new_with_subject'
    post '/create/id_user_to/:user_id', to: 'messages#create', as: 'message_create'
    post '/create/id_user_to/:user_id/subject/:subject', to: "messages#create", as: 'message_create_with_subject'
    post '/reply/:id/to/:user_id', to: 'messages#reply', as: 'message_reply'
  end

  # rss
  # nolotirov2 - legacy
  # FIX: las URLs legacy vienen asi
  # /en                     /rss/feed/woeid/766273                     /ad_type/give
  # Lo solucionamos en el nginx.conf y una configuracion para hacer el search and replace
  # http://stackoverflow.com/questions/22421522/nginx-rewrite-rule-for-replacing-space-whitespace-with-hyphen-and-convert-url-to
  scope '/rss' do
    get '/feed/woeid/:woeid/ad_type/:type', format: 'rss', to: 'rss#feed', as: 'rss_type'
    get '/feed/woeid/:woeid/ad_type/give/status/:status', format: 'rss', to: 'rss#feed', as: 'rss_status'
  end

  # contact
  get '/contact', to: 'contact#new', as: 'contacts'
  post '/contact', to: 'contact#create'

end
