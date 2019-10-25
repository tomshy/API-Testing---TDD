FROM ruby:2.6.4
RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN bundle install -j4 --retry 5