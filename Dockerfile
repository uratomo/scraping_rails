FROM ruby:2.3.7
RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfilep
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
