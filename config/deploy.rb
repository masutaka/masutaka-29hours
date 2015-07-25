# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'masutaka-29hours'
set :repo_url, 'git@github.com:masutaka/masutaka-29hours.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/masutaka-29hours'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, %w{29hours/log 29hours/tmp/pids 29hours/vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :bundle_gemfile, -> { release_path.join('29hours', 'Gemfile') }
set :bundle_path, -> { shared_path.join('29hours', 'vendor', 'bundle') }
set :git_strategy, Capistrano::Git::SubmoduleStrategy

namespace :deploy do
  desc 'Get settings.yml'
  before :updated, :setting_file do
    on roles(:all) do
      # Use `capture` instead of `execute` for not displaying environment variable in CircleCI
      capture "cd #{release_path}/29hours && curl -Ls -o settings.yml #{ENV.fetch('SETTINGS_FILE_PATH')}"
    end
  end

  desc 'Restart 29hours'
  after :publishing, :restart do
    on roles(:app) do
      invoke 'twenty_nine_hours:stop'
      invoke 'twenty_nine_hours:start'
    end
  end
end
