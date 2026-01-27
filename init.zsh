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
    p6m7g8-dotfiles/p6df-java
    p6m7g8-dotfiles/p6df-js
    p6m7g8-dotfiles/p6df-python
    p6m7g8-dotfiles/p6df-go
    p6m7g8-dotfiles/p6df-ruby
    p6m7g8-dotfiles/p6df-rust
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

  p6df::modules::vscode::extension::install AmazonWebServices.aws-toolkit-vscode
  p6df::modules::vscode::extension::install loganarnett.lambda-snippets
  p6df::modules::vscode::extension::install aws-cloudformation.cloudformation-linter

  p6_return_void
}

######################################################################
#<
#
# Function: str json = p6df::modules::aws::vscodes::config()
#
#  Returns:
#	str - json
#
#>
######################################################################
p6df::modules::aws::vscodes::config() {

  cat <<'EOF'
  "aws.telemetry": false,
EOF

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
  p6df::core::homebrew::cli::brew::install awscli
  p6df::core::homebrew::cli::brew::install aws-simple-ec2-cli

  # cloudformation / elastic beanstalk
  p6df::core::homebrew::cli::brew::install cloudformation-cli
  p6df::core::homebrew::cli::brew::install cfn-lint

  p6df::core::homebrew::cli::brew::install awsebcli

  # eks/ecs
  brew tap weaveworks/tap
  p6df::core::homebrew::cli::brew::install weaveworks/tap/eksctl

  # vpn
  p6df::core::homebrew::cli::brew::install aws-vpn-client --cask

  # lightsail
  p6df::core::homebrew::cli::brew::install lightsailctl

  # athena
  p6df::core::homebrew::cli::brew::install athenacli

  # iam
  p6df::core::homebrew::cli::brew::install homebrew/core/aws-iam-authenticator
  p6df::core::homebrew::cli::brew::install aws-sso-cli
  p6df::core::homebrew::cli::brew::install aws-sso-util
  p6df::core::homebrew::cli::brew::install aws-vault --formula

  # logs
  p6df::core::homebrew::cli::brew::install awslogs

  # shell/cli
  p6df::core::homebrew::cli::brew::install aws-shell

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
  # XXX: Convert to uv
  # pip install boto3
  # pip install taskcat
  # pip install ec2instanceconnectcli
  # pip install aws-sso-lib
  # pyenv rehash

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

  local orgs=$(curl -s https://aws.github.io | p6_filter_row_select "https://github.com" | p6_filter_row_exclude "project_name" \
    | p6_filter_extract_after "com/" \
    | p6_filter_extract_before "\"" \
    | p6_filter_column_pluck 1 "/" \
    | p6_filter_sort)
  local org
  for org in $(p6_echo "$orgs"); do
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
  curl -o "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR"/p6df-aws/libexec/aws-eks-kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.34.2/2025-11-13/bin/darwin/amd64/kubectl

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
#  Environment:	 P6_DFZ_SRC_DIR USER
#>
######################################################################
p6df::modules::aws::home::symlink::creds() {

  local file
  for file in "$P6_DFZ_SRC_DIR/$USER"/home-private/aws/*; do
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
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::init() {
  local _module="$1"
  local dir="$2"

  p6_bootstrap "$dir"

  p6_path_if "$P6_DFZ_SRC_DIR/aws/aws-codebuild-docker-images/local_builds"
  p6_path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec"

  p6_return_void
}

######################################################################
#<
#
# Function: stream  = p6df::modules::aws::profiles::list()
#
#  Returns:
#	stream - 
#
#>
######################################################################
p6df::modules::aws::profiles::list() {

  functions | p6_filter_row_select_regex '^p6_awsa' | p6_filter_column_pluck 1

  p6_return_stream
}

######################################################################
#<
#
# Function: str str = p6df::modules::aws::prompt::mod()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_DFZ_PROFILE_AWS P6_NL
#>
######################################################################
p6df::modules::aws::prompt::mod() {

  local str
  if ! p6_string_blank "$P6_DFZ_PROFILE_AWS"; then
    local prefix="AWS:\t\t  $P6_DFZ_PROFILE_AWS:"
    local active=$(p6_aws_cfg_prompt_info "_active")
    local source=$(p6_aws_cfg_prompt_info "_source")
    local saved=$(p6_aws_cfg_prompt_info "_saved")

    local sts=$(p6_aws_sts_prompt_info "$(p6_aws_env_shared_credentials_file_active)")
    local item
    for item in "$active" "$source" "$saved"; do
      if ! p6_string_blank "$item"; then
        str=$(p6_string_append "$str" "$prefix $item" "$P6_NL")
      fi
    done
    str=$(p6_string_append "$str" "$sts" " ")

    str=$(p6_echo "$str" | perl -p -e 's,^\s*,,')
  fi

  p6_return_str "$str"
}

######################################################################
#<
#
# Function: p6df::modules::aws::profile::on(profile, [aws_org=])
#
#  Args:
#	profile -
#	OPTIONAL aws_org - []
#
#  Environment:	 P6_AWS_ORG P6_DFZ_PROFILE_AWS
#>
######################################################################
p6df::modules::aws::profile::on() {
  local profile="$1"
  local aws_org="${2:-}"

  p6_env_export "P6_DFZ_PROFILE_AWS" "$profile"

  p6_env_export P6_AWS_ORG "$aws_org"
  p6_aws_cli_organization_on "$P6_AWS_ORG"
  p6df::modules::aws::profiles::list

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::profile::off()
#
#  Environment:	 P6_AWS_ORG P6_DFZ_PROFILE_AWS
#>
######################################################################
p6df::modules::aws::profile::off() {

    p6_env_export_un P6_DFZ_PROFILE_AWS
    p6_env_export_un P6_AWS_ORG

    p6_aws_cli_organization_off

    p6_return_void
}
