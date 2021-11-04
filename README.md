# vault-sidecar-injector-demo
vault up and running with Kubernetes 

## Dependency
- minikube
- vault server

# start vault server

```shell
vault server -dev -dev-listen-address your_local_ip:8200
```

# start minikube
```
minikube start
```


# configure vault
./vault-config.sh

Copy the role-id and secret id and update the `vault.sh` script
```
export role_id="2221ade4-783a-46d7-8d43-a2db3be07af1"
export secret_id="4edc177f-7a84-d354-0d1b-677206f861f7"
```

# run demo application

./vault.sh
![plot](../images/pod-running-with-vault.png)