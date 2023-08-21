#!/bin/bash

# Defina a senha desejada para o usuário root do MySQL
MYSQL_ROOT_PASSWORD="Fkztec@123456"

echo Atualiza os pacotes do sistema
sudo dnf update -y

echo Instala o servidor MySQL
sudo dnf install mysql-server -y

echo Inicia o serviço do MySQL
sudo systemctl start mysqld

echo Configura o MySQL para iniciar automaticamente no boot
sudo systemctl enable mysqld

echo Executa o script de segurança do MySQL para definir a senha do usuário root
sudo mysql_secure_installation <<EOF

n
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
y
y
y
y
EOF

echo "Instalação e configuração do MySQL 8 completas!"