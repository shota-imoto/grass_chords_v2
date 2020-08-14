FROM ruby:2.5.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    nodejs  \
    default-mysql-client  \
    build-essential  \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /grasschords

COPY Gemfile /grasschords/Gemfile
COPY Gemfile.lock /grasschords/Gemfile.lock

ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler && bundle install
RUN bundle exec rails assets:precompile RAILS_ENV=production

COPY . /grasschords