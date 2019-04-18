function get_cam_bearer_token() {
    PARAM_CAM_IP=${1}
    PARAM_AUTH_USER=${2}
    PARAM_AUTH_PASSWORD=${3}
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
    PARAM_CAM_IP=${1}
    PARAM_AUTH_USER=${2}
    PARAM_AUTH_PASSWORD=${3}

    get_cam_bearer_token ${PARAM_CAM_IP} ${PARAM_AUTH_USER} ${PARAM_AUTH_USER}
    CAM_TENANT_ID=`curl -k -X GET \
    https://$PARAM_CAM_IP:30000/cam/tenant/api/v1/tenants/getTenantOnPrem \
    -H 'Content-Type: application/json' \
    -H 'Authorization: bearer '$CAM_TOKEN | jq --raw-output '.id'`
}