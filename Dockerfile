FROM ruby:3.0.0

# Update the package lists before installing
RUN apt-get update -qq

# Install base packages
RUN apt-get install -y \
    build-essential \
    vim \
    nano \
    postgresql-client \
    && rm -rf /var/lib/apt/lists

# Install node 17 from source
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash - \
  && apt-get install -y nodejs

# Install yarn from source
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y yarn

# Create working directory
ENV APP_HOME /usr/src/app
RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

# Copy Gemfile
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 2.2.3 --no-document
RUN bundle install

# Copy app files
COPY . .

# Expose port
EXPOSE 3000

# Start
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]