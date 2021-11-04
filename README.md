# vault-sidecar-injector-demo
vault up and running with Kubernetes 

## Dependency
- minikube
- vault server

# start vault server
vault server -dev -dev-listen-address your_local_ip:8200

# start minikube
minikube start



# configure vault
./vault-config.sh

# run demo application

./vault.sh