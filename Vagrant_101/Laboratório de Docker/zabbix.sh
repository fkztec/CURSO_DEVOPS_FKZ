#!/bin/bash

# Define o fuso horário desejado
TIMEZONE="America/Sao_Paulo"

# Atualiza a lista de pacotes
sudo apt update

# Instala as dependências necessárias
sudo apt install -y wget

# Baixa a chave GPG do repositório oficial do Zabbix
wget https://repo.zabbix.com/zabbix-official-repo.key

# Adiciona a chave GPG ao sistema
sudo apt-key add zabbix-official-repo.key

# Adiciona o repositório oficial do Zabbix ao sistema
sudo apt-add-repository 'deb http://repo.zabbix.com/zabbix/5.0/ubuntu bionic main'

# Atualiza a lista de pacotes novamente
sudo apt update

# Instala o Zabbix Server, Frontend, Agent 2 e outras ferramentas
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent2

# Configura o fuso horário no PHP
sudo sed -i "s/^;date.timezone =$/date.timezone = $TIMEZONE/" /etc/php/7.2/apache2/php.ini

# Configura o banco de dados do Zabbix
sudo mysql -u root -e "CREATE DATABASE zabbix character set utf8 collate utf8_bin;"
sudo mysql -u root -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Zabbix@123';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Importa o esquema e os dados iniciais para o banco de dados do Zabbix
sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | sudo mysql -u zabbix -p zabbix

# Configura o Zabbix Server
sudo sed -i 's/# DBPassword=/DBPassword=Zabbix@123/' /etc/zabbix/zabbix_server.conf

# Reinicia os serviços do Zabbix Server e do Apache
sudo systemctl restart zabbix-server zabbix-agent2 apache2

# Habilita e inicia o serviço do Zabbix Server e do Apache na inicialização do sistema
sudo systemctl enable zabbix-server zabbix-agent2 apache2

# Habilita e inicia o serviço do Zabbix Agent 2 na inicialização do sistema
sudo systemctl enable zabbix-agent2

# Limpa o cache dos repositórios
sudo apt clean all

echo "A instalação do Zabbix 5 com Zabbix Agent 2 foi concluída com sucesso!"
