# Capistrano::DatabaseYml

Capistrano tasks for handling `database.yml` when deploying Rails 4+ apps.
This is a slightly modified clone of [capistrano-secrets-yml](https://github.com/capistrano-plugins/capistrano-secrets-yml).

### Install

Add this to `Gemfile`:

    group :development do
      gem 'capistrano', '~> 3.2.1'
      gem 'capistrano-database-yml', '~> 1.0.0'
    end

And then:

    $ bundle install

### Setup and usage

- make sure your local `config/database.yml` is not git tracked. It **should be on
  the disk**, but gitignored.

- populate production database in local `config/database.yml`:

        production:
          adapter: mysql2

- add to `Capfile`:

        require 'capistrano/database_yml'

- create `database.yml` file on the remote server by executing this task:

        $ bundle exec cap production setup

You can now proceed with other deployment tasks.

#### What if a new config is added to database file?

- add it to local `config/database.yml`:

        production:
          adapter: mysql2
          foobar: some_other_config

- if you're working in a team where other people have the deploy rights, compare
  you local `database.yml` with the one on the server. This is to ensure you
  didn't miss an update.
- copy to the server:

        $ bundle exec cap production setup

- notify your colleagues that have the deploy rights that the remote
  `database.yml` has been updated so they can change their copy.

### How it works

When you execute `$ bundle exec production setup`:

- database from your local `database.yml` are copied to the server.<br/>
- only "stage" database are copied: if you are deploying to `production`,
  only production database are copied there
- on the server database file is located  in `#{shared_path}/config/database.yml`

On deployment:

- database file is automatically symlinked to `#{current_path}/config/database.yml`

### Configuration

None.

### More Capistrano automation?

Check out [capistrano-plugins](https://github.com/capistrano-plugins) github org.

### FAQ

- shouldn't we be keeping configuration in environment variables as per
  [12 factor app rules](http://12factor.net/config)?

  On Heroku, yes.<br/>
  With Capistrano, those env vars still have to be written somewhere on the disk
  and used with a tool like [dotenv](https://github.com/bkeepers/dotenv).

  Since we have to keep configuration on the disk anyway, it probably makes
  sense to use Rails 4 built-in `database.yml` mechanism.

### License

[MIT](LICENSE.md)
