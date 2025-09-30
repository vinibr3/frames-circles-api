FROM ruby:3.4.4

ENV LANG C.UTF-8
ENV APP_DIR /usr/src/app

RUN apt-get update -qq && apt-get install -y nodejs

RUN apt-get install -y nodejs npm

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR ${APP_DIR}

COPY . .
RUN bundle install

RUN echo 'alias rspec="RAILS_ENV=test bundle exec rake db:drop && RAILS_ENV=test bundle exec rake db:prepare && RAILS_ENV=test bundle exec rspec"' >> ~/.bashrc

EXPOSE 3013
EXPOSE 8812

# Runs a rails server command to start the rails server, pointing it to local host.
CMD ["rails", "server", "-b", "0.0.0.0", "-p","3013"]
