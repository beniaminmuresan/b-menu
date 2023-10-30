FROM ruby:3.2.2

WORKDIR /server

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . /server

EXPOSE 3000