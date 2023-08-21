#/bin/bash

# Aumente max_map_count no seu host (Linux)
sysctl -w vm.max_map_count=262144

# install git 

sudo apt install git -y

# Clone o repositório Wazuh em seu sistema:
sudo git clone https://github.com/wazuh/wazuh-docker.git -b v4.4.5

# Execute o seguinte comando para obter os certificados desejados:
