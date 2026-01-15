# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::aws::sso::login()
#
#  Environment:	 AWS_PROFILE
#>
######################################################################
p6df::modules::aws::sso::login() {

 AWS_PROFILE=login aws-sso-util login

 p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::sso::populate()
#
#  Environment:	 AWS_CONFIGURE_SSO_DEFAULT_PROFILE_NAME_SEPARATOR AWS_PROFILE PROCESS_FORMATTER_ARGS
#>
######################################################################
p6df::modules::aws::sso::populate() {

 AWS_PROFILE=login \
	 AWS_CONFIGURE_SSO_DEFAULT_PROFILE_NAME_SEPARATOR=/ \
	 PROCESS_FORMATTER_ARGS="account_namerole_name" \
	 aws-sso-util \
	 configure \
	 populate \
	 --region us-east-1

 p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::sso::console()
#
#>
######################################################################
p6df::modules::aws::sso::console() {

  local sso_start_url=$(p6_aws_env_sso_start_url_active)
  local sso_region="$(p6_aws_env_region_active)"
  local role_name="$(p6_aws_svc_sts_account_role_name)"
  local account_id="$(p6_aws_svc_sts_account_id)"

  aws-sso-util console launch \
	  --sso-start-url "$sso_start_url" \
	  --sso-region "$sso_region" \
	  --account-id "$account_id" \
	  --role-name "$role_name"

  p6_return_void
}
