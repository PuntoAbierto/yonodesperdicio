server 'beta.yonodesperdicio.org', user: 'yonodesp', roles: %w{db web app}, port: 333

set :stage, :production
set :rails_env, 'production'
set :deploy_to, '/home/yonodesp/ruby/prod.ynd'
set :branch, "production"
