###############################################################################
# Stage 1: Build
FROM ruby:3.0.0 as builder

# Install base packages
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    vim \
    nano \
    postgresql-client && \
    rm -rf /var/lib/apt/lists

# Install node 17 from source
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs

# Install yarn from source
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y yarn

# Set env variables
ENV BUNDLER_VERSION 2.2.3
ENV BUNDLE_JOBS 8
ENV BUNDLE_RETRY 5
ENV BUNDLE_WITHOUT development:test
ENV BUNDLE_CACHE_ALL true
ENV APP_HOME /app
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

# Set working directory
WORKDIR $APP_HOME

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $BUNDLER_VERSION --no-document
RUN bundle config --global frozen 1 && \
  bundle install && \
  rm -rf /usr/local/bundle/cache/*.gem && \
  find /usr/local/bundle/gems/ -name "*.c" -delete && \
  find /usr/local/bundle/gems/ -name "*.o" -delete

# Install node packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --non-interactive --production

# Copy app files
ADD . $APP_PATH

# Precompile assets
# SECRET_KEY_BASE=`bin/rake secret` is added here as a workaround for
# https://github.com/rails/rails/issues/32947
RUN SECRET_KEY_BASE=`bin/rake secret` rails assets:precompile --trace && \
  yarn cache clean && \
  rm -rf node_modules tmp/cache vendor/assets test

###############################################################################
# Stage 2: Run
FROM ruby:3.0.0

RUN mkdir -p /app
WORKDIR /app

ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV APP_HOME /app

# Copy necessary data at runtime
COPY --from=builder /usr/lib /usr/lib

# Copy gems
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy app files
COPY --from=builder $APP_HOME $APP_HOME