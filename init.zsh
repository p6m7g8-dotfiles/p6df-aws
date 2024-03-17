# shellcheck shell=bash
######################################################################
#<
#
# Function: p6df::modules::aws::deps()
#
#>
######################################################################
p6df::modules::aws::deps() {
  ModuleDeps=(
    p6m7g8-dotfiles/p6df-docker
    p6m7g8-dotfiles/p6df-java p6m7g8-dotfiles/p6df-js p6m7g8-dotfiles/p6df-python p6m7g8-dotfiles/p6df-go p6m7g8-dotfiles/p6df-ruby p6m7g8-dotfiles/p6df-rust
    p6m7g8-dotfiles/p6aws
  )
}

######################################################################
#<
#
# Function: p6df::modules::aws::vscodes()
#
#>
######################################################################
p6df::modules::aws::vscodes() {

  code --install-extension AmazonWebServices.aws-toolkit-vscode
  code --install-extension iann0036.live-share-for-aws-cloud9
  code --install-extension vscode-aws-console.vscode-aws-console
  code --install-extension loganarnett.lambda-snippets

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::external::brew()
#
#>
######################################################################
p6df::modules::aws::external::brew() {

  # base
  brew tap aws/tap
  brew install awscli
  brew install aws-simple-ec2-cli

  # cloudformation / elastic beanstalk
  brew install cloudformation-cli
  brew install cfn-lint

  brew install awsebcli

  # eks/ecs
  brew tap weaveworks/tap
  brew install weaveworks/tap/eksctl

  brew install amazon-ecs-cli

  # vpn
  brew install aws-vpn-client --cask

  # copilot
  brew install copilot-cli

  # lightsail
  brew install lightsailctl

  # athena
  brew install athenacli

  # iam
  brew install homebrew/core/aws-iam-authenticator
  brew install aws-sso-cli
  brew install aws-sso-util
  brew install aws-vault

  # logs
  brew install awslogs

  # shell/cli
  brew install aws-shell

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::js()
#
#>
######################################################################
p6df::modules::aws::langs::js() {

  p6_js_npm_global_install "aws-sdk"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::ruby()
#
#>
######################################################################
p6df::modules::aws::langs::ruby() {

  p6_msg "gem install aws-sdk"
  gem install aws-sdk
  rbenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::python()
#
#>
######################################################################
p6df::modules::aws::langs::python() {

  # python
  pip install boto3
  pip install taskcat
  pip install ec2instanceconnectcli
  pip install aws-sso-lib
  pyenv rehash

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::go()
#
#>
######################################################################
p6df::modules::aws::langs::go() {

  go get github.com/aws/aws-sdk-go

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::rust()
#
#>
######################################################################
p6df::modules::aws::langs::rust() {

  cargo install cfn-guard
  cargo install cfn-guard-lambda
  cargo install cfn-guard-rulegen
  cargo install cfn-guard-rulegen-lambda
  # cargo install cfn-custom-resource
  # cargo install cfn-resource-provider

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::clones()
#
#  Environment:	 P6_DFZ_SRC_FOCUSED_DIR
#>
######################################################################
p6df::modules::aws::langs::clones() {

  local orgs=$(curl -s https://aws.github.io | grep https://github.com | grep -v project_name | sed -e 's,.*com/,,' -e 's,".*,,' -e 's,/,,' | sort)
  local org
  for org in $(p6_echo $orgs); do
    p6_github_login_clone "$org" "$P6_DFZ_SRC_FOCUSED_DIR"
  done

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::langs() {

  # languages
  p6df::modules::aws::langs::js
  p6df::modules::aws::langs::python
  p6df::modules::aws::langs::go
  p6df::modules::aws::langs::ruby
  p6df::modules::aws::langs::rust

  # codebuild local
  docker pull amazon/aws-codebuild-local:latest --disable-content-trust=false

  # eks kubectl client
  curl -o $P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec/aws-eks-kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/darwin/amd64/kubectl

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::home::symlink()
#
#  Environment:	 HOME P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::home::symlink() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/share/.aws" ".aws"

  p6_run_dir "$HOME/.aws" p6df::modules::aws::home::symlink::creds

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::home::symlink::creds()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::aws::home::symlink::creds() {

  local file
  for file in $P6_DFZ_SRC_DIR/$USER/home-private/aws/*; do
    p6_file_symlink "$file" "."
  done

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::init()
#
#  Environment:	 P6_AWS_ORG P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::init() {

  p6_path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/aws/aws-codebuild-docker-images/local_builds"
  p6_path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec"

  p6_aws_cli_organization_activate "$P6_AWS_ORG"
  functions | grep ^p6_awsa | cut -f 1 -d ' '

  p6_return_void
}

######################################################################
#<
#
# Function: str str = p6df::modules::aws::prompt::line()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_NL
#>
######################################################################
p6df::modules::aws::prompt::line() {

  local active=$(p6_aws_cfg_prompt_info "_active")
  local source=$(p6_aws_cfg_prompt_info "_source")
  local saved=$(p6_aws_cfg_prompt_info "_saved")

  local sts=$(p6_aws_sts_prompt_info "$(p6_aws_env_shared_credentials_file_active)")

  local str
  local item
  for item in "$active" "$source" "$saved"; do
    if ! p6_string_blank "$item"; then
      str=$(p6_string_append "$str" "$item" "$P6_NL")
    fi
  done
  str=$(p6_string_append "$str" "$sts" " ")

  str=$(p6_echo $str | perl -p -e 's,^\s*,,')

  p6_return_str "$str"
}

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
	 populate

 p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::env::prompt::info()
#
#>
######################################################################
p6df::modules::aws::env::prompt::info() {

  p6_aws_cfg_show
}

######################################################################
#<
#
# Function: p6df::modules::aws::svc::codebuild::projectbuild::list()
#
#  Environment:	 AWS_CODEBUILD_PROJECT_NAME
#>
######################################################################
p6df::modules::aws::svc::codebuild::projectbuild::list() {

  p6_aws_svc_codebuild_project_build_list "$AWS_CODEBUILD_PROJECT_NAME"
}
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
# Function: p6df::modules::aws::svc::ec2::rtbs::show()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::rtbs::show() {

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
# Function: p6df::modules::aws::svc::ec2::ids::get()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::ec2::ids::get() {

  p6_aws_svc_ec2_subnet_ids_get "$AWS_VPC_ID"
}
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
# Function: p6df::modules::aws::svc::sg::show(security_group_id)
#
#  Args:
#	security_group_id -
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::sg::show() {
  local security_group_id="$1"

  p6_aws_svc_ec2_sg_show "$security_group_id" "$AWS_VPC_ID"
}
######################################################################
#<
#
# Function: p6df::modules::aws::svc::sg::id_from_group_name()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::sg::id_from_group_name() {

  p6_aws_svc_ec2_sg_id_from_tag_name "$AWS_VPC_ID"
}
######################################################################
#<
#
# Function: p6df::modules::aws::svc::sgs::list()
#
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6df::modules::aws::svc::sgs::list() {

  p6_aws_svc_ec2_sgs_list "$AWS_VPC_ID"
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

######################################################################
#<
#
# Function: p6df::modules::aws::console()
#
#>
######################################################################
p6df::modules::aws::console() {

  local sso_start_url=$(p6_aws_env_sso_start_url_active)
  local sso_region="$(p6_aws_env_region_active)"
  local role_name="$(p6_aws_svc_sts_account_role_name)"
  local account_id="$(p6_aws_svc_sts_account_id)"

  aws-sso-util console launch \
	  --sso-start-url $sso_start_url \
	  --sso-region $sso_region \
	  --account-id $account_id \
	  --role-name $role_name

  p6_return_void
}
