RELEASE_NAME=demoapp1
NAMESPACE=default
ENVIRONMENT=develop
export role_id="8053be94-a86e-b58b-a9b0-4fcdbfaeba43"
export secret_id="615de8a4-7027-e08e-cf8c-c01bcf366cfb"
export VAULT_ADDR="http://192.168.1.2:8200"
export VAULT_TOKEN=$(vault write -field="token"  auth/approle/login role_id="${role_id}" secret_id="${secret_id}")
echo $VAULT_TOKEN
vault kv metadata  get kv/${NAMESPACE}/${ENVIRONMENT}/${RELEASE_NAME} >/dev/null || vault kv put kv/${NAMESPACE}/${ENVIRONMENT}/${RELEASE_NAME} ENV_SOURCE=$RELEASE_NAME  >/dev/null
vault policy read ${NAMESPACE}-${ENVIRONMENT}-${RELEASE_NAME} >/dev/null || (export POLI=$(echo "path \"kv/data/${NAMESPACE}/${ENVIRONMENT}/*\" { capabilities = [\"read\", \"list\"] }") && echo $POLI | vault policy write  ${NAMESPACE}-${ENVIRONMENT}-${RELEASE_NAME} -)
vault read auth/kubernetes/role/${NAMESPACE}-${RELEASE_NAME} >/dev/null || vault write auth/kubernetes/role/${NAMESPACE}-${RELEASE_NAME} bound_service_account_names=${RELEASE_NAME} bound_service_account_namespaces=${NAMESPACE} policies=admin ttl=1h
helm upgrade --install $RELEASE_NAME helm-chart --set environment=$ENVIRONMENT --set nameOverride=$RELEASE_NAME






#  curl      --request POST      --data '{"jwt": "'$TOKEN_REVIEW_SJWT'", "role": "default-demoapp"}' https://vault-cluster.vault.c1c633fa-91ef-4e86-b025-4f31b3f14730.aws.hashicorp.cloud:8200