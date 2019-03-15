# I am a thief: https://gist.github.com/ssaunier/8c88cbdce09d47581975
namespace :db do
  desc "Backs up heroku database and restores it locally."
  task import_from_heroku: [ :environment, :create ] do
    HEROKU_APP_NAME = nil
    config = Rails.configuration.database_configuration[Rails.env]

    heroku_app_flag = HEROKU_APP_NAME ? " --app #{HEROKU_APP_NAME}" : nil
    filename = "#{Date.today.to_s}.dump"

    Bundler.with_clean_env do
      SOURCE_DATABASE_URL = `heroku config:get DATABASE_URL #{heroku_app_flag}`.strip

      Rails.logger.info "[1/3] Dumping source database."
      `pg_dump #{SOURCE_DATABASE_URL} --verbose --format=c --file=tmp/#{filename}`

      Rails.logger.info "[2/3] Restoring backup to local database"
      `pg_restore --jobs=4 --clean --verbose --no-acl --no-owner -h localhost -d #{config["database"]} tmp/#{filename}`

      Rails.logger.info "[3/3] Removing local backup"
      `rm tmp/latest.dump`

      Rails.logger.info "Done."
    end
  end
end