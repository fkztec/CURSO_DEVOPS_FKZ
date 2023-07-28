#!/bin/bash

# Atualiza a lista de pacotes
sudo apt update

# Instala o MariaDB
sudo apt install mariadb-server

# Inicia o serviço do MariaDB
sudo systemctl start mariadb

# Configura o MariaDB para iniciar automaticamente na inicialização do sistema
sudo systemctl enable mariadb

# Executa o script de segurança do MariaDB para definir a senha do usuário root e outras configurações de segurança
sudo mysql_secure_installation

# Cria a base de dados do Zabbix
sudo mysql -u root -p -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;"

# Cria um usuário para a base de dados do Zabbix e define a senha
sudo mysql -u root -p -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '';"

# Concede as permissões necessárias ao usuário para a base de dados do Zabbix
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"

# Atualiza as permissões
sudo mysql -u root -p -e "FLUSH PRIVILEGES"

# Verifica o status do serviço do MariaDB
sudo systemctl status mariadb