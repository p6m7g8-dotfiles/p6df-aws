# shellcheck shell=bash}
######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::rtbs::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::rtbs::list() {

  p6_aws_svc_ec2_rtbs_list "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::rtb::show()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::rtb::show() {

  p6_aws_svc_ec2_rtb_show "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::network::init::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::network::init::list() {

  p6_aws_svc_ec2_network_int_list "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::instances::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::instances::list() {

  p6_aws_svc_ec2_instances_list "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::nat::gateway::show()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::nat::gateway::show() {

  p6_aws_svc_ec2_nat_gateway_show "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::subnet::get()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::subnet::get() {

  p6_aws_svc_ec2_subnet_get "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::subnets::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::subnets::list() {

  p6_aws_svc_ec2_subnets_list "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::subnetids::get()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::subnetids::get() {

  p6_aws_svc_ec2_subnet_ids_get "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::sg::show(security_group_id)
#
#  Args:
#	security_group_id -
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::sg::show() {
  local security_group_id="$1"

  p6_aws_svc_ec2_sg_show "$security_group_id" "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::sg::id_from_tag_name()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::sg::id_from_tag_name() {

  p6_aws_svc_ec2_sg_id_from_tag_name "$AWS_VPC_ID"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::ec2::sgs::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::sgs::list() {

  p6_aws_svc_ec2_sgs_list "$AWS_VPC_ID"
}
