# ----------------------------------------------------------------------------
#   INSTALACAO AUTOMATIZADA ZABBIX 6 NO ORACLE LINUX 8
# ---------------------------------------------------------------------------- 
#
clear
echo "#--------------------------------------------------------#"
echo      "INFORMANDO A SENHA DO BANCO DE DADOS DO ZABBIX"
echo "#--------------------------------------------------------#"
password="Fkztec@2022"
# read -p "Digite a senha do banco de dados: " password
#
clear
echo "#--------------------------------------------------------#"
echo "INSTALANDO REPOSITORIO, ZABBIX SERVER, AGENT, SENDER E GET"
echo "#--------------------------------------------------------#"
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-4.el8.noarch.rpm
dnf clean all
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2 zabbix-get zabbix-sender -y
#
clear
echo "#--------------------------------------------------------#"
echo         "CONFIGURANDO BANCO DE DADOS DO ZABBIX"
echo "#--------------------------------------------------------#"
zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p$password zabbix
sed -i '130s/^/DBPassword='$password'/' /etc/zabbix/zabbix_server.conf
#
clear
echo "#--------------------------------------------------------#"
echo            "AJUSTANDO ARQUIVO DO NGINX E PHP"
echo "#--------------------------------------------------------#"
sed -i 's/#        listen/        listen/' /etc/nginx/conf.d/zabbix.conf
sed -i 's/8080/80/' /etc/nginx/conf.d/zabbix.conf
sed -i '42s/^/#/' /etc/nginx/nginx.conf
sed -i '43s/^/        root         \/usr\/\share\/\zabbix;'/ /etc/nginx/nginx.conf
sed -i 's/post_max_size = 8M/post_max_size = 16M/' /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/' /etc/php.ini
#
clear
echo "#--------------------------------------------------------#"
echo      "COLOCANDO SERVIÇOS NO BOOT DO S.O E REINICIANDO"
echo "#--------------------------------------------------------#"
systemctl restart zabbix-server zabbix-agent2 nginx php-fpm
systemctl enable zabbix-server zabbix-agent2 nginx php-fpm
#
clear
echo "#-----------------------------------------#"
echo      "LIBERANDO A PORTA 80 NO FIREWALL"
echo "#-----------------------------------------#"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload 
systemctl restart firewalld
#
clear
echo "#--------------------------------------------------------#"
echo                          "FIM" 
echo              "ACESSE http://IP_DO_SERVIDOR"
echo "#--------------------------------------------------------#"
#



