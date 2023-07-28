#/bin/sh

# Execute o seguinte comando para desinstalar todos os pacotes conflitantes:
 for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Configurar o repositório
# Atualize o aptíndice do pacote e instale os pacotes para permitir apto uso de um repositório por HTTPS:

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

# Adicione a chave GPG oficial do Docker:

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Use o seguinte comando para configurar o repositório:

echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualize o aptíndice do pacote:
 
# Para instalar a versão mais recente, execute:

sudo apt-get install containerd.io -y