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

generate "rspec:install"
run "guard init rspec"

git :init
git add: "."
git commit: "-a -m 'Initial commit'"
