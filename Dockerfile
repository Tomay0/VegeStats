FROM ruby:3.0.0-alpine

ENV APP_PORT=80
EXPOSE $APP_PORT

RUN apk add --update --no-cache build-base nodejs yarn tzdata postgresql-dev postgresql-client libxslt-dev libxml2-dev

WORKDIR /vegestats
COPY . /vegestats/

RUN gem install rails
RUN gem install bundler

RUN bundle update && bundle install

ENTRYPOINT ["/bin/sh"]
CMD ["-c", "rm -rf /vegestats/tmp/pids/server.pid && rails s -p $APP_PORT -b 0.0.0.0"]