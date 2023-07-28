#/bin/bash

# ### Iniciando o cluster Kubernetes

# Agora é a hora de iniciar o cluster Kubernetes, então eu vou executar o comando de inicialização do cluster.
#  Esse comando, você vai executar APENAS NA MÁQUINA QUE VAI SER O CONTROL PLANE !!!
# Comando de inicialização

kubeadm init


kubeadm token create --print-join-command >> join_token.sh


# Instalação do CNI

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml