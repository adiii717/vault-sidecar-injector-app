# vault-sidecar-injector-app
vault up and running with Kubernetes

- using local vault server
- using vault enterprise

**Note: Kubernetes cluster should be reachable to vault enterprise for authentication, so vault enterprise would not able to communicate with your local minikube cluster.  [Check Minikube with ec2](https://www.google.com)
**

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

# vault enterprise

The only change for vault enterprise is the namespace for vault, by default its admin.
https://github.com/Adiii717/vault-sidecar-injector-app/blob/main/helm-chart/values.yaml#L21
set this to true to inject `namespace`
```yaml
vault:
  enterprise: 
    enabled: false
```
**Note: Kubernetes cluster should be reachable to vault enterprise for authentication, so you can not connect  from local machine using minikube to vault enterprise.
**

# configure vault
configure vault and enable auth,approle etc
```shell
./vault-config.sh

```
Copy the role-id and secret id and update the `vault.sh` script
```shell
export role_id="2221ade4-783a-46d7-8d43-a2db3be07af1"
export secret_id="4edc177f-7a84-d354-0d1b-677206f861f7"
```
![configure vault auth and approle](https://github.com/Adiii717/vault-sidecar-injector-demo/blob/main/images/pod-running-with-vault.png)



# run demo application

```shell
./vault.sh
```

# Vault enterprise with minikube ec2

To 

![running pods](https://github.com/Adiii717/vault-sidecar-injector-demo/blob/main/images/pod-running-with-vault.png)

