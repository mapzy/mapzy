FROM gitpod/workspace-postgres
USER gitpod

# Install the Ruby version specified in '.ruby-version'
COPY --chown=gitpod:gitpod .ruby-version /tmp
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm reinstall ruby-$(cat /tmp/.ruby-version) && rvm use ruby-$(cat /tmp/.ruby-version) --default && gem install rails rubocop rubocop-performance rubocop-rails rubocop-rspec"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc

# Install Chrome (used for Capybara/Selenium)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN sudo apt-get update 
RUN sudo apt-get install google-chrome-stable -y

# Install Redis
RUN sudo apt-get update && sudo apt-get install -y redis-server && sudo rm -rf /var/lib/apt/lists/*