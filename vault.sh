RELEASE_NAME=demoapp1
NAMESPACE=default
ENVIRONMENT=develop
export role_id="ba601346-1ae2-c557-84d1-9fdb7846b08a"
export secret_id="ddb26504-219a-93bc-6dec-d37cb62d7ed6"
export VAULT_ADDR="http://192.168.1.2:8200"
export VAULT_TOKEN=$(vault write -field="token"  auth/approle/login role_id="${role_id}" secret_id="${secret_id}")
echo $VAULT_TOKEN
vault kv metadata  get kv/${NAMESPACE}/${ENVIRONMENT}/${RELEASE_NAME} >/dev/null || vault kv put kv/${NAMESPACE}/${ENVIRONMENT}/${RELEASE_NAME} ENV_SOURCE=$RELEASE_NAME  >/dev/null
vault policy read ${NAMESPACE}-${ENVIRONMENT}-${RELEASE_NAME} >/dev/null || (export POLI=$(echo "path \"kv/data/${NAMESPACE}/${ENVIRONMENT}/*\" { capabilities = [\"read\", \"list\"] }") && echo $POLI | vault policy write  ${NAMESPACE}-${ENVIRONMENT}-${RELEASE_NAME} -)
vault read auth/kubernetes/role/${NAMESPACE}-${RELEASE_NAME} >/dev/null || vault write auth/kubernetes/role/${NAMESPACE}-${RELEASE_NAME} bound_service_account_names=${RELEASE_NAME} bound_service_account_namespaces=${NAMESPACE} policies=${NAMESPACE}-${ENVIRONMENT}-${RELEASE_NAME} ttl=1h
helm upgrade --install $RELEASE_NAME helm-chart --set environment=$ENVIRONMENT --set nameOverride=$RELEASE_NAME

