#resource "null_resource" "ImportVM" {
#  provisioner "local-exec" {
#    command = "chmod 755 ${path.module}/scripts/import_vm_by_id.sh && ${path.module}/scripts/import_vm_by_id.sh -h ${var.cam_hostname} -u ${var.cam_username} -p ${var.cam_password} -i ${var.cam_instancename} -n ${var.cam_namespace} -c ${var.cam_cloudconnection_id} -t ${var.cam_template_id} -o ${var.cloud_instance_id}"
#  }
#}

#resource "camc_scriptpackage" "FetchIPV4" {
#  depends_on = ["null_resource.ImportVM"]
  
#  program = ["svrInfo=$(cat ./ipv4);", "if [ -z $svrInfo ]; then echo '{}'; else echo $svrInfo; fi"]
#  on_create = true
#}


data "external" "import" {
  program = ["/bin/bash", "${path.module}/scripts/import_vm_by_id_external.sh"]
  query = {
    host  = "${var.cam_hostname}"
    user  = "${var.cam_username}"
    password = "${var.cam_password}"
    instance_name = "${var.cam_instancename}"
    instance_namespace = "${var.cam_namespace}"
    cloud_connection_id = "${var.cam_cloudconnection_id}"
    template_id = "${var.cam_template_id}"
    id_from_provider = "${var.cloud_instance_id}"
  }
}