gem_group :development, :test do
  gem "rspec-rails"
  gem "guard-rspec", require: false
  gem "factory_girl_rails"
end

gem_group :test do
  gem "shoulda-matchers"
  gem "database_cleaner"
  gem "cucumber-rails", require: false
  gem "selenium-webdriver"
  gem "faker"
end

if yes?("Install devise?")
  gem "devise"
  generate "devise:install"
  model_name = ask("What do you want to call the devise model (Default: User)?")
  model_name = "User" if model_name.blank?
  generate "devise #{model_name}"
end

generate "rspec:install"

file 'spec/support/capybara.rb', <<-CODE
RSpec.configure do |config|
  config.include Capybara::DSL, :type => :request

  Capybara.run_server = true
  Capybara.server_port = 3100
  Capybara.app_host = 'http://localhost:3100'
  Capybara.default_wait_time = 5

  Capybara.register_driver :chrome do |app|
    args = []
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)
  end

  Capybara.javascript_driver = :chrome
  Capybara.default_driver = :chrome
end
CODE

file 'spec/support/db_cleaner.rb', <<-CODE
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
CODE

run "guard init rspec"

rake "db:migrate"

git :init
git add: "."
git commit: "-a -m 'Initial commit'"

