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
  p6df::modules::homebrew::cli::brew::install awscli
  p6df::modules::homebrew::cli::brew::install aws-simple-ec2-cli

  # cloudformation / elastic beanstalk
  p6df::modules::homebrew::cli::brew::install cloudformation-cli
  p6df::modules::homebrew::cli::brew::install cfn-lint

  p6df::modules::homebrew::cli::brew::install awsebcli

  # eks/ecs
  brew tap weaveworks/tap
  p6df::modules::homebrew::cli::brew::install weaveworks/tap/eksctl

  p6df::modules::homebrew::cli::brew::install amazon-ecs-cli

  # vpn
  p6df::modules::homebrew::cli::brew::install aws-vpn-client --cask

  # copilot
  p6df::modules::homebrew::cli::brew::install copilot-cli

  # lightsail
  p6df::modules::homebrew::cli::brew::install lightsailctl

  # athena
  p6df::modules::homebrew::cli::brew::install athenacli

  # iam
  p6df::modules::homebrew::cli::brew::install homebrew/core/aws-iam-authenticator
  p6df::modules::homebrew::cli::brew::install aws-sso-cli
  p6df::modules::homebrew::cli::brew::install aws-sso-util
  p6df::modules::homebrew::cli::brew::install aws-vault

  # logs
  p6df::modules::homebrew::cli::brew::install awslogs

  # shell/cli
  p6df::modules::homebrew::cli::brew::install aws-shell

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
    p6df::modules::github::ext::parallel::clone "$org" "$P6_DFZ_SRC_FOCUSED_DIR"
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
# Function: p6df::modules::aws::init(_module, dir)
#
#  Args:
#	_module -
#	dir -
#
#  Environment:	 P6_AWS_ORG P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6_path_if "$P6_DFZ_SRC_DIR/aws/aws-codebuild-docker-images/local_builds"
  p6_path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec"

  p6_aws_cli_organization_on "$P6_AWS_ORG"
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
# Function: p6df::modules::aws::env::prompt::info()
#
#>
######################################################################
p6df::modules::aws::env::prompt::info() {

  p6_aws_cfg_show
}
