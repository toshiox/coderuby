FROM ruby:3.3.4

WORKDIR /rails/app

COPY ./Gemfile ./Gemfile.lock ./

RUN bundle install

COPY ./app .

EXPOSE 4567

CMD ["ruby", "app.rb"]