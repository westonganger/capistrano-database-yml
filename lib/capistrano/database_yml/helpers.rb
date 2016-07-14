require "yaml"

module Capistrano
  module DatabaseYml
    module Helpers

      def local_database_yml(env)
        @local_database_yml ||= YAML.load_file(database_yml_local_path)
        @local_database_yml[env]
      end

      def database_yml_env
        fetch(:database_yml_env).to_s
      end

      def database_yml_content
        { database_yml_env => local_database_yml(database_yml_env) }.to_yaml
      end

      # error helpers

      def check_git_tracking_error
        puts
        puts "Error - please remove '#{fetch(:database_yml_local_path)}' from git:"
        puts
        puts "    $ git rm --cached #{fetch(:database_yml_local_path)}"
        puts
        puts "and gitignore it:"
        puts
        puts "    $ echo '#{fetch(:database_yml_local_path)}' >> .gitignore"
        puts
      end

      def check_config_present_error
        puts
        puts "Error - '#{database_yml_env}' config not present in '#{fetch(:database_yml_local_path)}'."
        puts "Please populate it."
        puts
      end

      def check_database_file_exists_error
        puts
        puts "Error - '#{fetch(:database_yml_local_path)}' file does not exists, and it's required."
        puts
      end

    end
  end
end

