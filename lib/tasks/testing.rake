# Rails 4 has a bug which means using `task :default => ['spec:javascript']`
# will cause errors like `ActionView::Template::Error: wrong number of arguments (given 3, expected 1..2)`
# It looks related to https://github.com/rails/sass-rails/issues/253 and will
# be fixed in Rails 5. As a workaround we shell out to run the tests.
task :run_js_tests do
  sh "bundle exec rake spec:javascript"
end

task default: ['run_js_tests']
