#/bin/sh

# Instalação dos módulos do kernel
# Configuração dos parâmetros do sysctl, fica mantido mesmo com reebot da máquina.

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Aplica as definições do sysctl sem reiniciar a máquina
sudo sysctl --

# Adicionando o repositório do Docker

# Instalação de pré requisitos

sudo apt update && \
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

# Adicionando a chave GPG

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Configurando o repositório

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizando o repositório e instalando o containerd

sudo apt update && sudo apt install -y containerd.io -y

# Configuração padrão do Containerd

sudo mkdir -p /etc/containerd && containerd config default | sudo tee /etc/containerd/config.toml 

# Alterar o arquivo de configuração pra configurar o systemd cgroup driver. 
# Sem isso o Containerd não gerencia corretamente os recursos computacionais e vai reiniciar em loop

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Agora é preciso reiniciar o container

sudo systemctl restart containerdr

# Instalação do kubeadm, kubelet and kubectl

# Agora que eu tenho o container runtime instalado em todas as máquinas, chegou a hora de instalar o kubeadm, o kubelet e o kubectl. 
# Então vamos seguir as etapas e executar esses passos em TODAS AS MÁQUINAS.
# Atualizo os pacotes necessários pra instalação 

sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl

# Download da chave pública do Google Cloud

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
					https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Adiciono o repositório apt do Kubernetes

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Atualização do repositório apt e instalação das ferramenta

sudo apt-get update && \
sudo apt-get install -y kubelet kubeadm kubectl 

# Agora eu garanto que eles não sejam atualizados automaticamente. 

sudo apt-mark hold kubelet kubeadm kubectl 
