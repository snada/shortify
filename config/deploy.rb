require 'dotenv'
Dotenv.load

# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'shortify'
set :repo_url, 'git@github.com:snada/shortify.git'

set :deploy_to, ENV["SERVER_DEPLOY_FOLDER"]

# Select ruby version
set :rvm_ruby_version, proc { `cat .ruby-version`.chomp }

set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env')

set :keep_releases, 3

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
