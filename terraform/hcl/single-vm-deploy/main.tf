################################################################
# Module to deploy Single VM
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# Copyright IBM Corp. 2017.
#
################################################################
variable "openstack_image_id" {
  description = "The ID of the image to be used for deploy operations."
}

variable "openstack_flavor_id" {
  description = "The ID of the flavor to be used for deploy operations."
}

variable "openstack_network_name" {
  description = "The name of the network to be used for deploy operations."
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
  default = ""
}

variable "key_pair_name" {
  description = "The name of a ssh key pair which will be injected into the instance when they are created. The key pair must already be created and associated with the tenant's account. Changing key pair name creates a new instance."
  default = ""  
}

variable "instance_name" {
	description = "A unique instance name. If a name is not provided a name would be generated."	
}

# Generate a random padding
resource "random_id" "random_padding" {
  byte_length = "2"
}


provider "openstack" {
  insecure = true
  version  = "~> 1.17"
}

resource "openstack_compute_instance_v2" "vm_1" {	
  name      = "${var.instance_name}"
  image_id  = "${var.openstack_image_id}"
  flavor_id = "${var.openstack_flavor_id}"
  key_pair  = "${var.key_pair_name}"

  network {
    name = "${var.openstack_network_name}"
  }
}

#output "single-vm-ip" {
#  value = "${element(openstack_compute_instance_v2.single-vm.*.network.0.fixed_ip_v4,0)}"
#}
