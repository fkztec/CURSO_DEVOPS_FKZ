#!/bin/bash
echo "Informações para a instalação do Zabbix"
ZABBIX_PASSWORD="Fkztec@123456"  # Senha do banco de dados do Zabbix

echo "MySQL - Criação do banco e do usuário"
mysql -uroot -p -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -p -e "create user zabbix@localhost identified by 'ZABBIX_PASSWORD';"
mysql -uroot -p -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -uroot -p -e "set global log_bin_trust_function_creators = 1;"

echo "Atualiza os pacotes do sistema"
sudo dnf update -y

# Instala os pacotes necessários
sudo dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2 zabbix-get zabbix-sender -y

# Configuração do Zabbix Server
sudo sed -i 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf

# Reinicia o serviço do Zabbix Server
sudo systemctl restart zabbix-server zabbix-agent2

echo "Ajusta configurações do NGINX e PHP"
sudo sed -i 's/#        listen/        listen/' /etc/nginx/conf.d/zabbix.conf
sudo sed -i 's/8080/80/' /etc/nginx/conf.d/zabbix.conf
sudo sed -i '42s/^/#/' /etc/nginx/nginx.conf
sudo sed -i '43s/^/        root         \/usr\/\share\/\zabbix;'/ /etc/nginx/nginx.conf
sudo sed -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php.ini
sudo sed -i 's/max_input_time = 60/max_input_time = 300/' /etc/php.ini

# Reinicia o serviço do NGINX
sudo systemctl restart nginx

# Popula o banco de dados do Zabbix
zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -uzabbix -p$ZABBIX_PASSWORD zabbix

echo "Reinicia os serviços e coloca-os para iniciar no boot"
sudo systemctl restart zabbix-server zabbix-agent2 nginx php-fpm
sudo systemctl enable zabbix-server zabbix-agent2 nginx php-fpm

echo "Configura o firewall"
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload 
sudo systemctl restart firewalld

echo "Configuração e instalação do Zabbix concluídas! Acesse http://IP_DO_SERVIDOR para começar a usar."




