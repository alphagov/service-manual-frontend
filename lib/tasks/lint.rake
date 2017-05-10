desc "run ruby and sass linters"
task :lint do
  # Jenkins does its own linting
  next if ENV["JENKINS"]
  sh "govuk-lint-ruby --format html --out rubocop-${GIT_COMMIT}.html --format clang Gemfile app test config"
  sh "govuk-lint-sass app"
end

Rake::Task[:default].enhance [:lint]
