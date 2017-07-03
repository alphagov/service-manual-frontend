desc "run ruby and sass linters"
task :lint do
  next if ENV["JENKINS"]
  sh "govuk-lint-ruby --format clang Gemfile app test config"
  sh "govuk-lint-sass app"
end

Rake::Task[:default].enhance [:lint]
