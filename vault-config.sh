


kubectl apply -f k8-role.yaml


export VAULT_ADDR="http://192.168.1.2:8200"
vault login s.Gn96PxA82LElXiYb5CfHQCDG
# vault login root
helm repo add hashicorp https://helm.releases.hashicorp.com
helm upgrade --install vault hashicorp/vault --set "injector.externalVaultAddr=http://192.168.1.2:8200"

VAULT_HELM_SECRET_NAME=$(kubectl get secrets --output=json | jq -r '.items[].metadata | select(.name|startswith("vault-token-")).name')

kubectl describe secret $VAULT_HELM_SECRET_NAME
vault auth enable kubernetes

TOKEN_REVIEW_JWT=$(kubectl get secret $VAULT_HELM_SECRET_NAME --output='go-template={{ .data.token }}' | base64 --decode)

KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

KUBE_HOST=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')

vault write auth/kubernetes/config \
        token_reviewer_jwt="$TOKEN_REVIEW_JWT" \
        kubernetes_host="$KUBE_HOST" \
        kubernetes_ca_cert="$KUBE_CA_CERT" \
        issuer="https://kubernetes.default.svc.cluster.local"
vault auth enable approle
vault policy write admin admin-policy.hcl
vault write auth/approle/role/admin policies="admin"


#get role id

vault read auth/approle/role/admin/role-id

# generate secret
vault write -f  auth/approle/role/admin/secret-id


#Enable KV
vault secrets enable -version=2 kv