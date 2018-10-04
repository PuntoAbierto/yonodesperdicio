server 'beta.yonodesperdicio.org', user: 'capistrano', roles: %w{db web app}

set :stage, :production
set :rails_env, 'production'
#set :deploy_to, '/rails/beta.yonodesperdicio.org'
set :deploy_to, '/var/www/yonodesperdicio.org'
set :branch, "production"

set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'

set :passenger_port, 5001
set :passenger_cmd,  "bundle exec passenger"

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute "cd #{release_path} ; RAILS_ENV=staging bundle exec passenger start -p 5001 -d"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "cd #{release_path} ; RAILS_ENV=staging bundle exec passenger stop -p 5001"
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "cd #{release_path} ; touch tmp/restart.txt"
        end
      end
    end
  end

end
