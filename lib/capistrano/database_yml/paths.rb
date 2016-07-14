require "pathname"

module Capistrano
  module DatabaseYml
    module Paths

      def database_yml_local_path
        Pathname.new fetch(:database_yml_local_path)
      end

      def database_yml_remote_path
        shared_path.join fetch(:database_yml_remote_path)
      end

    end
  end
end
