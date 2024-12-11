#!/usr/bin/env bash

###############          SCRIPT CONFIGURAÇÃO DEBIAN 12 ######
# 									                                    
# posinstall_debian.sh -            			            
#									                                    
# Autor: Lucas Takeshi Arakaki (takeshioficial01@gmail.com)                          	
# Data Criação: 14/11/2024      		
#									                                    
# Descrição: instalar os programas e softwares necessários para meu uso no Debian 12                	                              
#	                                                                										                                    #
# Exemplo de uso: sudo ./posinstall_debian.sh	         		
#							                                    
#########################################################################

# ----------------------------- VARIÁVEIS ----------------------------- #
APT_PACKAGES=(
  vim
  git
  wget
  htop
  nmap
  neofetch
  net-tools
  openssh-server
  build-essential
  traceroute
  unzip
  zip
  rar
  p7zip
  p7zip-full
  ca-certificates
  apt-transport-https
  lsb-release
  software-properties-common 
  iproute2
  tmux
  flatpak
)

DKR_PACKAGES=(
  docker-ce 
  docker-ce-cli 
  containerd.io 
  docker-buildx-plugin 
  docker-compose-plugin
)

PHP_PACKAGES=(
  php8.3 
  php8.3-curl 
  php8.3-gd 
  php8.3-intl 
  php8.3-mbstring 
  php8.3-mysql 
  php8.3-xdebug
)
# ---------------------------------------------------------------------- #

echo -e "\033[01;32m Debian 12 Setting up \033[0m" 

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
echo -e "\033[01;32mRemoving eventually locks from apt\033[0m" 
sudo rm /var/lib/dpkg/lock-frontend; sudo rm /var/cache/apt/archives/lock ;

## Adicionando/Confirmando arquitetura de 32 bits ##
echo -e "\033[01;32mAdd 32 bits architecture to dpkg\033[0m" 
sudo dpkg --add-architecture i386

## Add non-free to official repositories
echo -e "\033[01;32mAdd contrib and non-free to official repositories\033[0m" 
sudo apt-add-repository contrib
sudo apt-add-repository non-free

## Atualizando o repositório ##
echo -e "\033[01;32mRunning the apt update\033[0m"
sudo apt update -y
# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
# Instalar programas no apt
echo -e "\033[01;32mInstalling apt packages\033[0m"
for nome_do_programa in ${APT_PACKAGES[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# -------Docker-------
echo -e "\033[01;32mDocker\033[0m"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# -------/Docker------

# -------PHP-------
echo -e "\033[01;32mPHP\033[0m"
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
# -------/PHP------

## Atualizando o repositório depois da adição de novos repositórios ##
echo -e "\033[01;32mRunning apt update after additions\033[0m"
sudo apt update -y

# -------FLATPAK-------
echo -e "\033[01;32mInstall the Software Flatpak plugin\033[0m"
sudo apt install gnome-software-plugin-flatpak
echo -e "\033[01;32mAdd the Flathub repository\033[0m"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# -------FLATPAK------

# Instalando Docker
echo -e "\033[01;32mInstalling docker packages\033[0m"
for nome_do_programa in ${DKR_PACKAGES[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# Instalando PHP
echo -e "\033[01;32mInstalling php packages\033[0m"
for nome_do_programa in ${PHP_PACKAGES[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
echo -e "\033[01;32mFinish the installations\033[0m"
echo -e "\033[01;32mUpdating and cleaning system\033[0m"
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean 
sudo apt autoremove -y

echo -e "\033[01;32;40mTHE END!\033[0m"
# ---------------------------------------------------------------------- #
