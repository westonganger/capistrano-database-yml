include Capistrano::DatabaseYml::Paths
include Capistrano::DatabaseYml::Helpers
namespace :load do task :defaults do
    set :database_yml_local_path, "config/database.yml"
    set :database_yml_remote_path, "config/database.yml"
    set :database_yml_env, -> { fetch(:rails_env) || fetch(:stage) }
  end
end

namespace :database_yml do

  task :check_database_file_exists do
    next if File.exists?(database_yml_local_path)
    check_database_file_exists_error
    exit 1
  end

  task :check_git_tracking do
    next unless system("git ls-files #{fetch(:database_yml_local_path)} --error-unmatch >/dev/null 2>&1")
    check_git_tracking_error
    exit 1
  end

  task :check_config_present do
    next unless local_database_yml(database_yml_env).nil?
    check_config_present_error
    exit 1
  end

  desc "database.yml file checks"
  task :check do
    invoke "database_yml:check_database_file_exists"
    invoke "database_yml:check_git_tracking"
    invoke "database_yml:check_config_present"
  end

  desc "Setup `database.yml` file on the server(s)"
  task setup: [:check] do
    content = database_yml_content
    on release_roles :all do
      execute :mkdir, "-pv", File.dirname(database_yml_remote_path)
      upload! StringIO.new(content), database_yml_remote_path
    end
  end

  # Update `linked_files` after the deploy starts so that users'
  # `database_yml_remote_path` override is respected.
  task :database_yml_symlink do
    set :linked_files, fetch(:linked_files, []).push(fetch(:database_yml_remote_path))
  end
  after "deploy:started", "database_yml:database_yml_symlink"

end

desc "Server setup tasks"
task :setup do
  invoke "database_yml:setup"
end
