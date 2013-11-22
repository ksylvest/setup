#!/bin/sh

VERSION=2.0.0-p247

# Step 1. Initialize Profiles

if [ ! -f ~/.profile ]
then
  touch ~/.profile
fi

if [ ! -f ~/.zprofile ]
then
  touch ~/.zprofile
fi

# Step 2. Configuring Paths

if [ -e ~/.config/fish/config.fish ]
then
  if ! grep -q ' /usr/local/bin' ~/.config/fish/config.fish || ! grep -q ' /usr/local/sbin' ~/.config/fish/config.fish
  then
    echo "Configuring: ~./config/fish/config.fish"
    sh -c "cat > ~/.config/fish/config.fish <<EOS
set fish_greeting ""
set PATH /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
set PATH /Users/kevin/.rbenv/bin $PATH
set PATH /Users/kevin/.rbenv/shims $PATH
rbenv rehash
EOS
"
  else
    echo "Configured: ~./config/fish/config.fish"
  fi
fi

if ! grep -q '/usr/local/bin' /etc/paths || ! grep -q '/usr/local/sbin' /etc/paths
then
  echo "Configuring: /etc/paths"
  sudo sh -c "cat > /etc/paths <<EOS
/usr/local/share/npm/bin
/usr/local/bin
/usr/bin
/bin
/usr/local/share/npm/sbin
/usr/local/sbin
/usr/sbin
/sbin
EOS
"
else
  echo "Configured: /etc/paths"
fi

# Step 3. Installing Brew

if [ ! -f /usr/local/bin/brew ]
then
  echo "Installing: brew"
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
else
  echo "Found: brew"
fi

if [ ! -f /usr/local/bin/qmake ]
then
  echo "Installing: qt"
  brew install qt --HEAD
else
  echo "Found: qt"
fi

if [ ! -f /usr/local/bin/zsh ]
then
  echo "Installing: zsh"
  brew install zsh
else
  echo "Found: zsh"
fi

if [ ! -f /usr/local/bin/bash ]
then
  echo "Installing: bash"
  brew install bash
else
  echo "Found: bash"
fi

if [ ! -f /usr/local/bin/fish ]
then
  echo "Installing: fish"
  brew install fish
else
  echo "Found: fish"
fi

if [ ! -f /usr/local/bin/git ]
then
  echo "Installing: git"
  brew install git
else
  echo "Found: git"
fi

if [ ! -f /usr/local/bin/ack ]
then
  echo "Installing: ack"
  brew install ack
else
  echo "Found: ack"
fi

if [ ! -f /usr/local/bin/node ]
then
  echo "Installing: node"
  brew install node
else
  echo "Found: node"
fi

if [ ! -f /usr/local/bin/convert ]
then
  echo "Installing: convert"
  brew install imagemagick
else
  echo "Found: convert"
fi

if [ ! -e /usr/local/bin/postgres ]
then
  echo "Installing: postgres"
  brew install postgresql
  initdb /usr/local/var/postgres -E utf8
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix postgres`/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
else
  echo "Found: postgres"
fi

if [ ! -f /usr/local/bin/elasticsearch ]
then
  echo "Installing: elasticsearch"
  brew install elasticsearch
  mkdir -p ~/Library/LaunchAgents
  ln -nfs `brew --prefix elasticsearch`/homebrew.mxcl.elasticsearch.plist ~/Library/LaunchAgents/
  launchctl load -wF ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
else
  echo "Found: elasticsearch"
fi

if [ ! -e /usr/local/bin/memcached ]
then
  echo "Installing: memcached"
  brew install memcached
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix memcached`/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
else
  echo "Found: memcached"
fi

if [ ! -e /usr/local/bin/redis-server* ]
then
  echo "Installing: redis"
  brew install redis
  mkdir -p ~/Library/LaunchAgents
  cp `brew --prefix redis`/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
else
  echo "Found: redis"
fi

# Step 4. Install RBENV

if [ ! -e ~/.gemrc ]
then
  echo "Configuring: ~/.gemrc"
  sh -c "cat > ~/.gemrc <<-EOS
gem: --no-ri --no-rdoc
EOS"
else
  echo "Configured: ~/.gemrc"
fi

if [ ! -e ~/.psqlrc ]
then
  echo "Configuring: ~/.psqlrc"
  sh -c "cat > ~/.psqlrc <<-EOS
\x auto
\timing
EOS"
else
  echo "Configured: ~/.psqlrc"
fi

if [ ! -e /usr/local/bin/rbenv ]
then
  brew install rbenv
  brew install rbenv-gem-rehash
fi

if [ ! -e /usr/local/bin/ruby-build ]
then
  brew install ruby-build
fi

if ! grep -q 'rbenv' ~/.profile
then
  echo 'eval "$(rbenv init -)"' >> ~/.profile
fi

if ! grep -q 'rbenv' ~/.zprofile
then
  echo 'eval "$(rbenv init -)"' >> ~/.zprofile
fi

eval "$(rbenv init -)"

if ! rbenv versions | grep -q $VERSION
then
  rbenv install $VERSION
  rbenv global $VERSION
fi

rbenv rehash

# Step 5. Install NPM

if [ ! -e /usr/local/bin/npm ]
then
  echo "Installing: npm"
  curl https://npmjs.org/install.sh | sh
else
  echo "Found: npm"
fi

if [ ! `which coffee` ]
then
  echo "Installing: coffee"
  npm install -g coffee-script
else
  echo "Found: coffee"
fi

if [ ! `which less` ]
then
  echo "Installing: less"
  npm install -g less
else
  echo "Found: less"
fi

if [ ! `which mocha` ]
then
  echo "Installing: mocha"
  npm install -g mocha
else
  echo "Found: mocha"
fi

# Step 6. Install POW

if [ ! -d ~/.pow ]
then
  echo "Installing: pow"
  curl get.pow.cx | sh
else
  echo "Found: pow"
fi

# Step 7. Configure GIT

echo "Configuring: git"
git config --global credential.helper osxkeychain

# Step 8. Install some gems...

gem install bundler
gem install powder
