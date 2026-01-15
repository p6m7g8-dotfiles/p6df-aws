# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::aws::svc::eks::cluster::status()
#
#  Environment:	 AWS_EKS_CLUSTER_NAME
#>
######################################################################
p6df::modules::aws::svc::eks::cluster::status() {

  p6_aws_svc_eks_cluster_status "$AWS_EKS_CLUSTER_NAME"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::eks::cluster::find()
#
#  Environment:	 AWS_EKS_CLUSTER_NAME
#>
######################################################################
p6df::modules::aws::svc::eks::cluster::find() {

  p6_aws_svc_eks_cluster_find "$AWS_EKS_CLUSTER_NAME"
}

# shellcheck disable=2329
######################################################################
#<
#
# Function: p6df::modules::aws::svc::eks::cluster::set(cluster_name)
#
#  Args:
#	cluster_name -
#
#  Environment:	 AWS_EKS_CLUSTER_NAME
#>
######################################################################
p6df::modules::aws::svc::eks::cluster::set() {

  p6_aws_svc_eks_cluster_set"$AWS_EKS_CLUSTER_NAME"
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::eks::cluster::set(cluster_name)
#
#  Args:
#	cluster_name -
#
#  Environment:	 AWS_EKS_CLUSTER_NAME
#>
######################################################################
p6df::modules::aws::svc::eks::cluster::set() {
  local cluster_name="$1"

  p6_env_export "AWS_EKS_CLUSTER_NAME" "$cluster_name"

  p6_aws_svc_eks_cluster_update_kubeconfig "$cluster_name"

  p6_return_void
}
