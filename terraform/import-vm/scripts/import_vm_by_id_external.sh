#!/bin/bash

set -x

# Get script parameters
eval "$(jq -r '@sh "PARAM_CAM_IP=\(.host) PARAM_AUTH_USER=\(.user) PARAM_AUTH_PASSWORD=\(.password) PARAM_INSTANCE_NAME=\(.["instance-name"]) PARAM_INSTANCE_NAMESPACE=\(.["instance-namespace"]) PARAM_CC_NAME=\(.["cloud-connection-id"]) PARAM_TEMPLATE_NAME=\(.["template-id"]) PARAM_ID_FROM_PROVIDER=\(.["id-from-provider"])"')"

printf "\033[33m [PARAM_CAM_IP: $PARAM_CAM_IP]\n\033[0m\n"
printf "\033[33m [PARAM_AUTH_USER: $PARAM_AUTH_USER]\n\033[0m\n"
printf "\033[33m [PARAM_INSTANCE_NAME: $PARAM_INSTANCE_NAME]\n\033[0m\n"
printf "\033[33m [PARAM_INSTANCE_NAMESPACE: $PARAM_INSTANCE_NAMESPACE]\n\033[0m\n"
printf "\033[33m [PARAM_CC_NAME: $PARAM_CC_NAME]\n\033[0m\n"
printf "\033[33m [PARAM_TEMPLATE_NAME: $PARAM_TEMPLATE_NAME]\n\033[0m\n"
printf "\033[33m [PARAM_ID_FROM_PROVIDER: $PARAM_ID_FROM_PROVIDER]\n\033[0m\n"

CAM_TOKEN=""

function get_cam_bearer_token() {
  printf "\033[33m [Retrieving bearer token for user $PARAM_AUTH_USER]\n\033[0m\n"
CAM_TOKEN=`curl -k -X POST \
  https://$PARAM_CAM_IP:8443/idprovider/v1/auth/identitytoken \
  -H 'Content-Type: application/json' \
  -d '{
"grant_type":"password",
"username":"'$PARAM_AUTH_USER'",
"password":"'$PARAM_AUTH_PASSWORD'",
"scope":"openid"
}' | jq --raw-output '.access_token'`
}

function get_cam_tenant() {
get_cam_bearer_token
printf "\033[33m [Retrieving the CAM tenant ID]\n\033[0m\n"
CAM_TENANT_ID=`curl -k -X GET \
  https://$PARAM_CAM_IP:30000/cam/tenant/api/v1/tenants/getTenantOnPrem \
  -H 'Content-Type: application/json' \
  -H 'Authorization: bearer '$CAM_TOKEN | jq --raw-output '.id'`
printf "\033[33m [CAM tenant ID : $CAM_TENANT_ID]\n\033[0m\n"  
}


function run_cam_import() {
   get_cam_tenant
   printf "\033[33m [Running the import VM command]\n\033[0m\n\033[0m\n"
  
  # call the import REST API
   CAM_INSTANCE_ID=`curl -k -X POST \
   'https://'$PARAM_CAM_IP':30000/cam/api/v1/stacks/import?tenantId='$CAM_TENANT_ID'&cloudOE_spaceGuid='$PARAM_INSTANCE_NAMESPACE \
  -H 'Content-Type: application/json' \
  -H 'Authorization: bearer '$CAM_TOKEN \
  -d '{
  "name": "'$PARAM_INSTANCE_NAME'",
  "cloudConnectionId": "'$PARAM_CC_NAME'",
  "templateId": "'$PARAM_TEMPLATE_NAME'",
  "idFromProvider": "'$PARAM_ID_FROM_PROVIDER'"
}' | jq --raw-output '.id'`

 # wait for the import job to 

  attempts=0
  exit_code=-1
  CAM_INSTANCE_STATUS=""
  until [ $attempts -ge 5 ]
  do
    CAM_INSTANCE_STATUS=`curl -k -X POST \
    'https://'$PARAM_CAM_IP':30000/cam/api/v1/stacks/'$CAM_INSTANCE_ID'/retrieve?tenantId='$CAM_TENANT_ID'&cloudOE_spaceGuid='$PARAM_INSTANCE_NAMESPACE \
    -H 'Content-Type: application/json' \
    -H 'Authorization: bearer '$CAM_TOKEN | jq --raw-output '.status'`
    printf "\033[33m [CAM Instance status: $CAM_INSTANCE_STATUS]\n\033[0m\n\033[0m\n"
    if [ "$CAM_INSTANCE_STATUS" == "SUCCESS" ]
    then
      exit_code=0
      break
    else
      echo "Sleeping 5 sec while waiting for the import to finish ...";
      sleep 5
    fi
    attempts=$[$attempts+1]
  done
  if [ $exit_code -eq 0 ]; then
      echo "Successfully imported instance "$CAM_INSTANCE_ID
      # dump the IP of the imported VM into a local file where it can be loaded from later in a script package
      IMPORTED_VM_IPV4=`curl -k -X POST \
    'https://'$PARAM_CAM_IP':30000/cam/api/v1/stacks/'$CAM_INSTANCE_ID'/retrieve?tenantId='$CAM_TENANT_ID'&cloudOE_spaceGuid='$PARAM_INSTANCE_NAMESPACE \
    -H 'Content-Type: application/json' \
    -H 'Authorization: bearer '$CAM_TOKEN | jq --raw-output '.data.details.resources[0].details.access_ip_v4'` 
    printf "\033[33m [Imported VM IPV4: $IMPORTED_VM_IPV4]\n\033[0m\n\033[0m\n"
    #echo $IMPORTED_VM_IPV4 > ./ipv4
    jq -n --arg ipv4 "$IMPORTED_VM_IPV4" '{"ipv4":$ipv4}'
  else
      echo "Failed to import instance "$CAM_INSTANCE_ID ". Instance status is "$CAM_INSTANCE_STATUS
      exit -1
  fi
}

run_cam_import