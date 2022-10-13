#!/bin/bash

######### Kubernetes Commands ###########
# @param1 action
# @param2 namespace
# @param3 project_name
#
# @action up
#     Upscale kubernetes deployment to 1
# @action down
#     Downscale kubernetes deployment to 0
kubeScriptUpScale() {
  echo "${RED}Up-scaling${NC} ${GREEN}${2}${NC}"
  commandPrint "kubectl scale -n ${1} deployment ${2} --replicas=1"
}

kubeScriptUpScaleBatch() {
  echo "Up-scaling All deployments..."
  for deployment in "${SERVICES[@]}"; do
    kubeScriptUpScale "$1" "$deployment"
    sleep 2m
  done
}

kubeScriptDownScale() {
  echo "${RED}Downscaling${NC} ${GREEN}${2}${NC}"
  commandPrint "kubectl scale -n ${1} deployment ${2} --replicas=0"
}

kubeScriptDownScaleBatch() {
  echo "${RED}Downscaling all deployments..."
  sleep 2s
  for deployment in "${SERVICES[@]}"; do
    kubeScriptDownScale "$1" "$deployment"
  done
}

kubeScriptRestart() {
  echo "${RED}Restarting${NC} ${GREEN}$2${NC}"
  kubeScriptDownScale "${1}" "${2}"
  sleep 30s
  kubeScriptUpScale "${1}" "${2}"
  sleep 3s
}

kubeScriptCustomScale() {
   ## TODO: Finish Custom Scaling
    echo "${RED}Custom Scaling"
    read -r -p "Enter deployment name: " depInput
    read -r -p "type up/down to upscale or downscale: " scaleInput
    kubeActions "$scaleInput" "$2" "$depInput"
}

SERVICES=(
  # core
  eclipse-deployment
  daisy-app-deployment
  securityconfiguration-ms-deployment

  # Microservices
  catalogueitemtype-ms-deployment
  payment-ms-deployment
  provider-ms-deployment
  contribution-ms-deployment
  costamount-ms-deployment
  financereference-ms-deployment
  financialassessment-ms-deployment
  fostercareapprovalmonitor-ms-deployment
  gazetteer-ms-deployment
  olmnginx-deployment
  purchaseoption-ms-deployment

  # Frontend Apps
  efm-payment-app-deployment
  efm-catalogue-app-deployment
  efm-financialassessment-app-deployment
  efm-remittance-app-deployment

  # Extra
  adjustment-ms-deployment
  audit-ms-deployment
  bandtemplate-ms-deployment
)

kubeScriptToken() {
  kubectl -n kube-system describe secret default | awk '$1=="token:"{print $2}'
}

kubeScriptProxy() {
  # shellcheck disable=SC2154
  commandPrint "start ${root_path}/helper/kubectl-proxy.sh"
  openUrl "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/deployment?namespace=$NAMESPACE"
  echo "A new Window is opened that runs the proxy in background"

  printf "\nToken: \n"
  kubeScriptToken
}

kubeScriptPortForward() {
  commandPrint "start \"${root_path}/helper/kubectl-port-forward.sh\" $NAMESPACE $PROJECT_NAME $1"
  echo "An external bash window is opened... It forces to stop any other services running on port 7000 (7001 if in debug mode). If the window closes within 10s, that normally means the pod is not running..."
}

kubeScriptGetNamespace() {
  commandPrint "kubectl get ns"
}

kubeScriptCreateNamespace() {
  input=""
  while [ -z "$input" ]; do
    read -r -p "Enter namespace name: " input
  done
  commandPrint "kubectl create ns $input"
}

####### Validate and set Pre Image Tag ####
kubeScriptPreTagSetter() {
  IMAGE_PRE_TAG=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT docker_pre_tag FROM runtime_vars");
  if [ -z "$IMAGE_PRE_TAG" ]; then
    read -r -p "Do you want to set Kubernetes image pre tag? (Y/n)" input
    if [ "$input" = "n" ]; then
      return
    fi
    kubeScripPreTagUpdate
  fi
  echo "IMAGE PRE TAG: $IMAGE_PRE_TAG"
}

### Force update Docker PreTag ####
# eu.gcr.io/olm-rd/efm
kubeScripPreTagUpdate() {
  input=""
  while [ -z "$input" ]; do
    read -r -p "Enter image pre tag: " input
  done
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET docker_pre_tag='$input' WHERE id=1"
  IMAGE_PRE_TAG="$input"
}

############# Read and Set Namespace ################
namespaceSetup() {
  ## Check namespace from runtime vars in db
  NAMESPACE=$("$SQLITE_EXEC_PATH" "$DB_NAME" "SELECT namespace FROM runtime_vars;")
  echo "NAMESPACE: $NAMESPACE"

  ## Check if no namespace provided yet
  NAMESPACE_QUERY="$NAMESPACE"
  while [ -z "$NAMESPACE_QUERY" ]; do
    read -r -p "Enter your kubernetes namespace: " NAMESPACE_QUERY
  done

  ## Update runtime vars table with new namespace name
  NAMESPACE="$NAMESPACE_QUERY"
  "$SQLITE_EXEC_PATH" "$DB_NAME" "UPDATE runtime_vars SET namespace='$NAMESPACE' WHERE id=1;"
}


autoPilotKubernetes() {
  autoPilotFlyMode 'k3' false
  sleep 2s
  autoPilotFlyMode 'k6' false
  sleep 2s
  autoPilotFlyMode 'k7' false
  sleep 2s
  echo "Rest Client will be opened in a second"
  openUrl "https://web.postman.co/home"
}