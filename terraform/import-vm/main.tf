  provisioner "local-exec" {
    command = "chmod 755 ${path.module}/scripts/import_vm.sh && ${path.module}/scripts/import_vm.sh -u ${var.cam_username} -p ${var.cam_password} -i ${var.cam_instancename} -n ${var.cam_namespace} -c ${var.cam_cloudconnection_id} -t ${var.cam_template_id} -o ${var.cloud_instance_id}"
  }
