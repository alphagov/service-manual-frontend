ARG base_image=ruby:2.7.5-slim-buster

FROM $base_image AS builder
# This image is only intended to be able to run this app in a production RAILS_ENV
ENV RAILS_ENV=production
# TODO: have a separate build image which already contains the build-only deps.
RUN apt-get update -qy && \
    apt-get upgrade -y && \
    apt-get install -y build-essential nodejs && \
    apt-get clean

RUN useradd rubytest

WORKDIR /app

USER rubytest

RUN chown -R rubytest: /app \
    && chmod -R u+w /app

COPY --chown=rubytest Gemfile Gemfile.lock .ruby-version /app/
RUN bundle config set force_ruby_platform true && \
    bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install --jobs 4 --retry=2
COPY --chown=rubytest . /app
# TODO: We probably don't want assets in the image; remove this once we have a proper deployment process which uploads to (e.g.) S3.
RUN GOVUK_APP_DOMAIN=www.gov.uk \
    GOVUK_WEBSITE_ROOT=https://www.gov.uk \
    bundle exec rails assets:precompile

FROM $base_image
ENV RAILS_ENV=production GOVUK_APP_NAME=service-manual-frontend
# bundler seems to need nodejs installed - or at least a JavaScript runtime
RUN apt-get update -qy && \
    apt-get upgrade -y && \
    apt-get install -y nodejs && \
    apt-get clean
USER rubytest
WORKDIR /app
COPY --chown=rubytest --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=rubytest --from=builder /app ./
CMD bundle exec puma
