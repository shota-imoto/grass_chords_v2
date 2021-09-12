#!/bin/sh
# install ruby
sudo apt-get install git-all -y
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv init
echo 'export PATH="~/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

CONFIGURE_OPTS='--disable-install-rdoc' rbenv install 2.7.1
rbenv global 2.7.1

# fetch grass chords application
git clone https://github.com/shota-imoto/grass_chords_v2.git
cd grass_chords_v2

gem install sassc -v '2.4.0'
gem install mysql2 -v '0.5.3'

bundle install