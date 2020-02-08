#!/bin/bash
#
#First run script for RHEL

hostname="sanfrancisco"

# Changing hostname...
sudo hostnamectl set-hostname ${hostname}

grep  "127.0.0.1 ${hostname}" /etc/hosts
if [[ $? != 0 ]]; then
  sudo echo "127.0.0.1 ${hostname}" >> /etc/hosts
fi

exit 1


break
echo "break"

sudo yum update -y
echo "Installing packages..."
sudo yum install -y git htop atop iotop zsh

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Enable ohmyzsh plugins
# by editing plugins=(git docker docker-compose)

# Install docker
echo "Installing docker & docker-compose..."
sudo amazon-linux-extras install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}
# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Adding alias git lgb to ~/.gitconfig"
# Add 'git lgb'
git config --global alias.lgb "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches"

