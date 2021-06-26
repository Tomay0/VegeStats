FROM ruby:3.0.0


EXPOSE $APP_PORT

RUN gem install rails
RUN gem install bundler
RUN apt-get update -qq && apt-get install -y nodejs npm
RUN npm install --global yarn

WORKDIR /vegestats
COPY ./Gemfile /vegestats
COPY ./Gemfile.lock /vegestats

RUN bundle update && bundle install
