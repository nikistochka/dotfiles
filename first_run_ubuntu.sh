#!/bin/bash
#
#First run script for Ubuntu


sudo apt-get -y update
echo "Installing packages..."
sudo apt-get -y install git htop atop iotop zsh mc tmux

# Install docker
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y update

sudo apt -y install docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Adding alias git lgb to ~/.gitconfig"
# Add 'git lgb'
git config --global alias.lgb "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches"

# Copy config files
cp config_files/.tmux.conf ~/.tmux.conf
mkdir -p ~/.vim/backup
cp config_files/.vimrc ~/.vimrc

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp config_files/robbyrussell.zsh-theme ~/.oh-my-zsh/custom/themes/robbyrussell.zsh-theme

# Enable ohmyzsh plugins
# by editing plugins=(git docker docker-compose)
