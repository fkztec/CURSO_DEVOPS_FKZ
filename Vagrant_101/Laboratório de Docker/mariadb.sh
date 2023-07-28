#!/bin/bash

# Atualiza a lista de pacotes
sudo apt update

# Instala o MariaDB Server
sudo apt install -y mariadb-server

# Inicia o serviço do MariaDB
sudo systemctl start mariadb

# Configura o MariaDB para iniciar automaticamente na inicialização do sistema
sudo systemctl enable mariadb

# Aguarda alguns segundos para garantir que o serviço tenha iniciado corretamente
sleep 10

# Instala o pacote expect, necessário para automatizar a interação com mysql_secure_installation
sudo apt install -y expect

# Define a senha para o usuário root do MariaDB
ROOT_PASSWORD="Zabbix@123"

# Script para configurar automaticamente o mysql_secure_installation
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn sudo mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"$ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$ROOT_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

# Remove o pacote expect após a configuração
sudo apt remove -y expect

# Reinicia o serviço do MariaDB
sudo systemctl restart mariadb