# vault-sidecar-injector-app
vault up and running with Kubernetes

- using local vault server
- using vault enterprise

**Note: Kubernetes cluster should be reachable to vault enterprise for authentication, so vault enterprise would not able to communicate with your local minikube cluster.  [Check Minikube with ec2](https://github.com/Adiii717/vault-sidecar-injector-app/blob/main/README.md#vault-enterprise-with-minikube-ec2)**

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
![running pods](https://github.com/Adiii717/vault-sidecar-injector-demo/blob/main/images/pod-running-with-vault.png)


# Vault enterprise with minikube ec2

Kubernetes cluster should be reachable to vault, otherwise the vault server will not able to authenticate and thus you might get weird  error. for example
```shell
  | Error making API request.
  |
  | URL: PUT https://vault-cluster.vault.c1c633fa-91ef-4e86-b025-4f31b3f14730.aws.hashicorp.cloud:8200/v1/admin/auth/kubernetes/login
  | Code: 403. Errors:
  |
  | * permission denied
   backoff=2.99s
 ```
 As this error does not indicate it has connectivity issue but this also happen when vault not able to communicate with Kubernetes cluster.
 
 
 ### start minikube in Ec2
Pass the EC2 public IP using `--apiserver-ips`

`--apiserver-ips ipSlice`            

>A set of apiserver IP Addresses which are used in the generated certificate for kubernetes.  This can be used if you want to make the apiserver available from outside the machine (default [])
      

 ```shell
 minikube start --apiserver-ips=14.55.145.29 --vm-driver=none
 ```

Now update the `vaul-config.sh` file

```
KUBE_HOST=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')
```
change this to
```
KUBE_HOST=""https://13.57.145.29:8443/"
```


