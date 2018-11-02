set :application, 'yonodesperdicio.org'
set :repo_url, 'git@github.com:mijailr/YND.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :bundle_flags, '--quiet'
set :bundle_bins, %w(rake rails)
set :bundle_path, nil

#set :deploy_via, :copy
set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true }

set :linked_files, %w{config/database.yml config/secrets.yml config/newrelic.yml vendor/geolite/GeoLiteCity.dat}
set :linked_dirs, %w{db/sphinx log tmp/pids tmp/cache tmp/sockets tmp/cachedir vendor/bundle public/system public/legacy public/.well-known public/assets}
set :tmp_dir, "/home/yonodesp/tmp"
set :keep_releases, 5
set :delayed_job_workers, 2

set :delayed_job_queues, ['mailer','notifications']

# Logical flow for deploying an app
# after  'deploy:finished',            'thinking_sphinx:index'
# after  'deploy:finished',            'thinking_sphinx:restart'
after  'deploy:finished',            'deploy:restart'

namespace :deploy do

  desc 'Perform migrations'
  task :migrations do
    on roles(:db) do
      within release_path do
        with rails_env:
          fetch(:rails_env) do execute :rake, 'db:migrate'
        end
      end
    end
  end

  desc 'restart app'
  task :restart do
    on roles(:all) do
      execute "touch #{ current_path }/tmp/restart.txt"
    end
  end

  before :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'nolotiro:cache:clear'
        end
      end
    end
  end

  after :finishing, 'deploy:cleanup'

end
