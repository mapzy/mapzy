FROM ruby:3.0.0

# Install nodejs v 14.x
RUN apt-get update -qq
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install nodejs -y
RUN node -v

# Add Yarn repository
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Yarn
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get install yarn -y
RUN npm install -g yarn


ADD . /usr/src/app
WORKDIR /usr/src/app


# Install & run bundler
RUN gem install bundler:'~> 2.1.4'

RUN bundle

# webpacker installation
RUN bundle exec rails webpacker:install

# install yarn packages
RUN yarn install


CMD rails server -b 0.0.0.0