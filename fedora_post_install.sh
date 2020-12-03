#!/usr/bin/env bash

##Simple Fedora Workstation (GNOME) Post-Installation Script

#Version 1.0
#Tested on Fedora 33 with bash 5.0.17


#------------Maintainer-----------# 

#Anderson do Bomfim
#Email: anderson.abomfim@gmail.com



#-----------Validations----------#

#Check if the user has root permission
if [ $(whoami) != root ]
    then
echo "You need to be have administrative privilegies to execute this script. Are you root?"
exit 1
    else
#Sync repositories and upgrade all packages
sudo dnf upgrade --refresh -y    
fi

wget_curl()
{
##Install wget if not installed
if [ $(which wget) == 1 ]
    then
sudo dnf install wget
fi

##Install Curl if not installed
if [ $(which curl) == 1 ]
    then
sudo dnf install curl 
fi
}


#--------------Execution----------#

##Add Repositories
add_repos()
{
#RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y 
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

#Add RPM Fusion in Gnome Software
sudo dnf groupupdate core -y

#Skype
sudo curl -o /etc/yum.repos.d/skype-stable.repo https://repo.skype.com/rpm/stable/skype-stable.repo 

#FlatHub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 
}


##Install Packages
install_pkgs()
{#RPM
sudo dnf groupupdate sound-and-video -y
dnf install slack*.rpm zoom*.rpm vagrant zsh vim htop VirtualBox ansible telegram-desktop tilix vlc transmission \
gnome-tweaks dropbox papirus-icon-theme git -y
#Flatpak
flatpak install flathub com.spotify.Client -y
flatpak install flathub us.zoom.Zoom -y 
flatpak install flathub com.slack.Slack -y
}

remove()
#Remove qemu and GNOME Boxes to avoid conflicts when using VirtualBox and Vagrant.
{
sudo dnf remove qemu* gnome-boxes* -y
}

zsh()
#Change shell to zsh and install oh-my-zsh framework
{
usermod -s /bin/zsh $USERNAME
usermod -s /bin/zsh root
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

execution ()
{
wget_curl
add_repos
install_pkgs
remove
zsh
}

execution
