# DOCKER COMANDOS

## Comando para buildar uma imagem
```
docker build -t "nome da image" "local do docker file"
```

## Comando Para gerenciar redes

### Lista rede no docker.
```
docker network ls
```
### Criadndo um rede no docker.
```
docker network create "nome da rede"
docker network create flasknetwork
```
### Criando uma rede com driver.
```
docker network create -d macvlan meumacvlan
```
### Removendo rede no docker.
```
docker network rm "nome da rede"
```
### Removendo rede inutilizada.
```
docker network prune
```
### Conectar um container a uma rede.

``` 
docker network connect "nome da rede" "nome ou id do container"
```

### Desconectar um container de uma rede.
```
docker network disconnect "nome da rede" "nome ou id do container"
```
### Inspecionando uma rede docker
```
docker network inspect "nome da rede"
```