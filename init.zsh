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

  code --install-extension amazonwebservices.aws-toolkit-vscode
  code --install-extension aws-amplify.aws-amplify-vscode
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

  # sam
  brew install aws-sam-cli

  # copilot
  brew install copilot-cli

  # lightsail
  brew install lightsailctl

  # athena
  brew install athenacli

  # iam
  brew install aws-iam-authenticator

  # logs
  brew install awslogs

  # shell/cli
  brew install aws-shell
  brew install aws-vault

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
  for item in "$active" "$source" "$saved" "$sts"; do
    if ! p6_string_blank "$item"; then
      str=$(p6_string_append "$str" "$item" "$P6_NL")
    fi
  done

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
