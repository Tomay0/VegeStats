FROM ruby:3.0.0-alpine

RUN apk add --update --no-cache build-base nodejs yarn tzdata postgresql-dev postgresql-client libxslt-dev libxml2-dev

RUN mkdir /vegestats
WORKDIR /vegestats

RUN gem install rails
RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

COPY . ./

#COPY entrypoint.sh /usr/bin/
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

ENV APP_PORT=80
EXPOSE $APP_PORT