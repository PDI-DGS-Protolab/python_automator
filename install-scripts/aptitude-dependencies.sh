#/bin/bash

echo  "Installing base platform dependencies!"

sudo apt-get remove -y ruby rubygems
sudo rm /usr/bin/gem /usr/bin/ruby

sudo apt-get install -y  git python2.7 python-pip
sudo easy_install virtualenv

sudo ln -s /usr/bin/python-pip /usr/bin/pip

sudo apt-get install ruby-rvm
sudo rvm install 1.9.2

sudo ln -s /usr/bin/gem1.9.1 /usr/bin/gem
sudo ln -s /usr/bin/ruby1.9.1 /usr/bin/ruby

sudo gem install foreman

echo  "Installing python automator!"

git clone https://github.com/PDI-DGS-Protolab/python_automator

echo 'export PATH=$PATH:$HOME/python_automator/' >> $HOME/.bashrc

echo  "Installing security updates!"

sudo apt-get -y upgrade

echo  "Installation FINISHED!"

source $HOME/.bashrc
