#!/bin/bash
# # Put credentials below

#### Docker Commands ##########
# @param1 action
# @param2 namespace
# @param3 project_name
#
# @action build
#     Build Docker Image
# @action push
#     Push Docker Image
dockerActions() {
  if [ "$1" == "build" ]; then
    echo "${GREEN}Building${NC} docker image for ${RED}project ${3}${NC}"
    commandPrint "docker build --network=host --tag eu.gcr.io/olm-rd/efm/${3}:${2} ."
  elif [ "$1" == "push" ]; then
    echo "${GREEN}Pushing${NC} ${RED}${3}${NC} docker image to cloud..."
    commandPrint "docker push eu.gcr.io/olm-rd/efm/${3}:${2}"
  fi
}

######### Kubernetes Commands ###########
# @param1 action
# @param2 namespace
# @param3 project_name
#
# @action up
#     Upscale kubernetes deployment to 1
# @action down
#     Downscale kubernetes deployment to 0
kubeActions() {
  if [ "$1" == "up" ]; then
    echo "${RED}Up-scaling${NC} ${GREEN}${3}${NC}"
    commandPrint "kubectl scale -n ${2} deployment ${3}-ms-deployment --replicas=1"
  elif [ "$1" == "upAll" ]; then
    echo "Up-scaling All deployments..."
    sleep 2m
    for deployment in "${SERVICES[@]}"; do
      kubeActions "up" "$2" "$deployment"
    done
  elif [ "$1" == "down" ]; then
    echo "${RED}Downscaling${NC} ${GREEN}${3}${NC}"
    commandPrint "kubectl scale -n ${2} deployment ${3}-ms-deployment --replicas=0"
  elif [ "$1" == "downAll" ]; then
    echo "${RED}Downscaling all deployments..."
    sleep 2s
    for deployment in "${SERVICES[@]}"; do
      kubeActions "down" "$2" "$deployment"
    done
  elif [ "$1" == "restart" ]; then
    echo "${RED}Restarting${NC} ${GREEN}$3${NC}"
    kubeActions "down" "${2}" "${3}"
    sleep 30s
    kubeActions "up" "${2}" "${3}"
    sleep 3s
  elif [ "$1" == "custom" ]; then
    ## TODO: Finish Custom Scaling
    echo "${RED}Custom Scaling"
    read -r -p "Enter deployment name: " depInput
    read -r -p "type up/down to upscale or downscale: " scaleInput
    kubeActions "$scaleInput" "$2" "$depInput"
  elif [ "$1" == "proxy" ]; then
    kubeProxy $2
  else
    echo "Invalid Selection ($1)"
  fi
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

kubeProxy() {
  # shellcheck disable=SC2154
  commandPrint "start ${root_path}/helper/kubectl-proxy.sh"
  echo "A new Window is opened that runs the proxy in background"
  openUrl "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/deployment?namespace=$1"
}

kubePortForward() {
  commandPrint "start \"${root_path}/helper/kubectl-port-forward.sh\" $NAMESPACE $PROJECT_NAME $1"
  echo "An external bash window is opened... It forces to stop any other services running on port 7000 (7001 if in debug mode). If the window closes within 10s, that normally means the pod is not running..."
}

kubeGetNamespace() {
  commandPrint "kubectl get ns"
}

kubeCreateNamespace() {
  input=""
  while [ -z "$input" ]; do
    read -r -p "Enter namespace name: " input
  done
  commandPrint "kubectl create ns $input"
}

gcloudLogin() {
  commandPrint "gcloud auth login"
}

gcloudInit() {
  commandPrint "gcloud init"
}
