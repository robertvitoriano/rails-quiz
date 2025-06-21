FROM ruby:3.3.1

RUN apt-get update -qq && apt-get install -y nodejs yarn build-essential libpq-dev

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
