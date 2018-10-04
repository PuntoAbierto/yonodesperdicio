server 'beta.yonodesperdicio.org', user: 'yonodesp', roles: %w{db web app}, port: 333

set :stage, :staging
set :rails_env, 'staging' 
set :deploy_to, '/home/yonodesp/ruby/beta.ynd'
set :branch, "staging"
