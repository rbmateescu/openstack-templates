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
#eval "$(jq -r '@sh "PARAM_CAM_IP=\(.host_name)"')"
#eval "$(jq -r '@sh "PARAM_AUTH_USER=\(.user)"')"
#eval "$(jq -r '@sh "PARAM_AUTH_PASSWORD=\(.password)"')"
#eval "$(jq -r '@sh "PARAM_INSTANCE_NAME=\(.instance_name)"')"
#eval "$(jq -r '@sh "PARAM_INSTANCE_NAMESPACE=\(.instance_namespace)"')"
#eval "$(jq -r '@sh "PARAM_CC_NAME=\(.cloud_connection_id)"')"
#eval "$(jq -r '@sh "PARAM_TEMPLATE_NAME=\(.template_id)"')"
#eval "$(jq -r '@sh "PARAM_ID_FROM_PROVIDER=\(.id_from_provider)"')"

#printf "\033[33m [PARAM_CAM_IP: $PARAM_CAM_IP]\n\033[0m\n"
#printf "\033[33m [PARAM_AUTH_USER: $PARAM_AUTH_USER]\n\033[0m\n"
#printf "\033[33m [PARAM_INSTANCE_NAME: $PARAM_INSTANCE_NAME]\n\033[0m\n"
#printf "\033[33m [PARAM_INSTANCE_NAMESPACE: $PARAM_INSTANCE_NAMESPACE]\n\033[0m\n"
#printf "\033[33m [PARAM_CC_NAME: $PARAM_CC_NAME]\n\033[0m\n"
#printf "\033[33m [PARAM_TEMPLATE_NAME: $PARAM_TEMPLATE_NAME]\n\033[0m\n"
#printf "\033[33m [PARAM_ID_FROM_PROVIDER: $PARAM_ID_FROM_PROVIDER]\n\033[0m\n"


jq -n '{"ipv4":"4.4.4.4"}'
#jq -n --arg ipv4 "$IMPORTED_VM_IPV4" '{"ipv4":$ipv4}'