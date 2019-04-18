#!/bin/bash

#set -x
# Get script parameters
#eval "$(jq -r '@sh "PARAM_CAM_IP=\(.host_name) 
#PARAM_AUTH_USER=\(.user_name) 
#PARAM_AUTH_PASSWORD=\(.password) 
#PARAM_INSTANCE_NAME=\(.instance_name) 
#PARAM_INSTANCE_NAMESPACE=\(.instance_namespace) 
#PARAM_CC_NAME=\(.cloud_connection_id) 
#PARAM_TEMPLATE_NAME=\(.template_id) 
#PARAM_ID_FROM_PROVIDER=\(.id_from_provider)"')"


PARAM_CAM_IP="9.30.214.48"
PARAM_AUTH_USER="admin"
PARAM_AUTH_PASSWORD="Passw0rd"
PARAM_INSTANCE_NAME=radu-import
PARAM_INSTANCE_NAMESPACE="default"
PARAM_CC_NAME="5c883247f9c98c00176278fa"
PARAM_TEMPLATE_NAME="5cae5a53b980c80017b4794f"
PARAM_ID_FROM_PROVIDER="338aefb7-6987-4c43-88d5-09351b549b7f"

source ./functions.sh

run_cam_import ${PARAM_CAM_IP} ${PARAM_AUTH_USER} ${PARAM_AUTH_PASSWORD} ${PARAM_INSTANCE_NAME} ${PARAM_INSTANCE_NAMESPACE} ${PARAM_CC_NAME} ${PARAM_TEMPLATE_NAME} ${PARAM_ID_FROM_PROVIDER}
  
jq -n --arg ipv4 "$IMPORTED_VM_IPV4" '{"ipv4":$ipv4}'
