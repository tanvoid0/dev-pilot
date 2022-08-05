#!/bin/bash
# # Put credentials below
project_name=$1
namespace=$2
action=$3

echo "Project $project_name $namespace $action"

enterToConinue(){
	printf "\n"
	read -n 1 -s -r -p $"Press ${RED}Enter (⏎)${NC} to continue..."
	read -e -t2
	printf "\033c"
}

kubeDeploy() {
	if [ "$action" == "build" ]; then
	  echo "Building docker imag for project $project_name"
	  docker build --network=host --tag eu.gcr.io/olm-rd/efm/${project_name}:${namespace} .
 	elif [ "$action" == "push" ]; then
  	echo "Pushing $project_name docker image to cloud..."
    docker push eu.gcr.io/olm-rd/efm/${project_name}:${namespace}
	 elif [ "$action" == "up" ]; then
	 	echo "Up-scaling $project_name"
	 	kubectl scale -n ${namespace} deployment ${project_name}-ms-deployment --replicas=1
	 elif [ "$action" == "down" ]; then
	 	echo "Downscaling $project_name"
	 	kubectl scale -n ${namespace} deployment ${project_name}-ms-deployment --replicas=0
	 elif [ "$action" == "restart" ]; then
	 	echo "Restarting $project_name"
	 	kubectl scale -n ${namespace} deployment ${project_name}-ms-deployment --replicas=0
	 	sleep 30s
	 	kubectl scale -n ${namespace} deployment ${project_name}-ms-deployment --replicas=1
	 else
	 	echo "Invalid Selection ($action)"
	 fi
}

kubeDeploy


# deployments=( 
#         # core
#         eclipse-deployment
#         daisy-app-deployment
#         securityconfiguration-ms-deployment

#         # Microservices
#         catalogueitemtype-ms-deployment
#         payment-ms-deployment
#         provider-ms-deployment
#         contribution-ms-deployment
#         costamount-ms-deployment
#         financereference-ms-deployment
#         financialassessment-ms-deployment
#         fostercareapprovalmonitor-ms-deployment
#         gazetteer-ms-deployment
#         olmnginx-deployment
#         purchaseoption-ms-deployment
        
#         # Frontend Apps
#         efm-payment-app-deployment
#         efm-catalogue-app-deployment
#         efm-financialassessment-app-deployment
#         efm-remittance-app-deployment
        
#         # Extra
#         adjustment-ms-deployment
#         audit-ms-deployment
#         bandtemplate-ms-deployment
#         )

# NAMESPACE=tan

# for d in "${deployments[@]}"
# do
#         kubectl scale -n $NAMESPACE deployment $d --replicas=1
#         sleep 2m
#         # sleep 5s
# done