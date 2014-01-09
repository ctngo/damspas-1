set :application, 'damspas'
set :repo_url, 'https://github.com/ucsdlib/damspas.git'

set :deploy_to, '/pub/capistrano'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/fedora.yml config/solr.yml config/initializers/secret_token.rb}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  namespace :assets do
    desc 'Pre-compile assets'
    task :precompile do
      on roles(:web) do
        run "cd #{release_path} && #{rake} RAILS_ENV=#{rails_env} assets:precompile"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc "Write the current version to publicl/revision.txt"
  task :write_version do
    on roles(:app), in: :sequence do
      within repo_path do
        execute :echo, "`git describe --all --always --long --abbrev=40 HEAD` `date +\"%Y-%m-%d %H:%M:%S %Z\"` #{ENV['CODENAME']} > #{release_path}/public/version.txt"
      end
    end
  end

  after :finishing, 'deploy:write_version'
  after :finishing, 'deploy:cleanup'

end
