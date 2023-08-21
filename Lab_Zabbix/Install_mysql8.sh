#!/bin/bash

# Defina aqui a senha desejada para o usuário root do MySQL
MYSQL_ROOT_PASSWORD="Fkztec@2022"

# Defina aqui as variáveis de configuração desejadas
MYSQL_MAX_CONNECTIONS=100
MYSQL_BUFFER_POOL_SIZE=256M
MYSQL_LOG_PATH="/var/log/mysql"

# Atualiza os pacotes do sistema
sudo yum update -y

# Instala o servidor MySQL
sudo yum install mysql-server -y

# Inicia o serviço do MySQL
sudo systemctl start mysqld

# Configura o MySQL para iniciar automaticamente no boot
sudo systemctl enable mysqld

# Pega a senha temporária gerada para o usuário root do MySQL
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

# Executa o script de segurança do MySQL para definir a senha do usuário root
sudo mysql_secure_installation <<EOF

n
$TEMP_PASSWORD
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
y
y
y
y
EOF

# Configuração das variáveis
sudo sed -i '/\[mysqld\]/a max_connections='$MYSQL_MAX_CONNECTIONS'\ninnodb_buffer_pool_size='$MYSQL_BUFFER_POOL_SIZE'\nlog_error='$MYSQL_LOG_PATH'/error.log' /etc/my.cnf

# Reinicia o serviço do MySQL para aplicar as configurações
sudo systemctl restart mysqld

echo "Instalação e configuração do MySQL 8 completas!"