#!/bin/bash

#set -x
# Get script parameters
eval "$(jq -r '@sh "PARAM_CAM_IP=\(.host_name) 
PARAM_AUTH_USER=\(.user_name) 
PARAM_AUTH_PASSWORD=\(.password) 
PARAM_INSTANCE_NAME=\(.instance_name) 
PARAM_INSTANCE_NAMESPACE=\(.instance_namespace) 
PARAM_CC_NAME=\(.cloud_connection_id) 
PARAM_TEMPLATE_NAME=\(.template_id) 
PARAM_ID_FROM_PROVIDER=\(.id_from_provider)"')"

source ./functions.sh

run_cam_import ${PARAM_CAM_IP} ${PARAM_AUTH_USER} ${PARAM_AUTH_PASSWORD} ${PARAM_INSTANCE_NAME} ${PARAM_INSTANCE_NAMESPACE} ${PARAM_CC_NAME} ${PARAM_TEMPLATE_NAME} ${PARAM_ID_FROM_PROVIDER}
  
jq -n --arg ipv4 "$IMPORTED_VM_IPV4" '{"ipv4":$ipv4}'
