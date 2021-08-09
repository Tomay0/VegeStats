FROM ruby:3.0.0

ENV APP_PORT=80

EXPOSE $APP_PORT

RUN gem install rails
RUN gem install bundler
RUN apt-get update -qq && apt-get install -y nodejs npm
RUN npm install --global yarn

WORKDIR /vegestats
COPY . /vegestats

RUN bundle update && bundle install

CMD ["sh", "-c", "bundle exec rails s -p $APP_PORT -b 0.0.0.0"]
