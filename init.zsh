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
    zxkane/aws-skills
    ahmedasmar/devops-claude-skills:aws-cost-optimization
  )
}

######################################################################
#<
#
# Function: p6df::modules::aws::path::init(_module, _dir)
#
#  Args:
#	_module -
#	_dir -
#
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::path::init() {

  local _module="$1"
  local _dir="$2"
  p6_path_if "$P6_DFZ_SRC_DIR/aws/aws-codebuild-docker-images/local_builds"
  p6_path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::home::symlinks()
#
#  Environment:	 HOME P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DOTFILES_DIR
#>
######################################################################
p6df::modules::aws::home::symlinks() {

  p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/share/.aws" "$HOME/.aws"

  p6_file_symlink "$P6_DFZ_SRC_DIR/zxkane/aws-skills/.claude/skills/aws-agentic-ai"                         "$HOME/.claude/skills/aws-agentic-ai"
  p6_file_symlink "$P6_DFZ_SRC_DIR/zxkane/aws-skills/.claude/skills/aws-cdk-development"                    "$HOME/.claude/skills/aws-cdk-development"
  p6_file_symlink "$P6_DFZ_SRC_DIR/zxkane/aws-skills/.claude/skills/aws-cost-operations"                    "$HOME/.claude/skills/aws-cost-operations"
  p6_file_symlink "$P6_DFZ_SRC_DIR/zxkane/aws-skills/.claude/skills/aws-mcp-setup"                          "$HOME/.claude/skills/aws-mcp-setup"
  p6_file_symlink "$P6_DFZ_SRC_DIR/zxkane/aws-skills/.claude/skills/aws-serverless-eda"                     "$HOME/.claude/skills/aws-serverless-eda"
  p6_file_symlink "$P6_DFZ_SRC_DIR/ahmedasmar/devops-claude-skills/aws-cost-optimization"                   "$HOME/.claude/skills/aws-cost-optimization"
  p6_file_symlink "$P6_DFZ_SRC_DIR/hashicorp/agent-skills/packer/builders/skills/aws-ami-builder"           "$HOME/.claude/skills/aws-ami-builder"
  p6_file_symlink "$P6_DFZ_SRC_DIR/hashicorp/agent-skills/packer/hcp/skills/push-to-registry"               "$HOME/.claude/skills/push-to-registry"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::external::brews()
#
#>
######################################################################
p6df::modules::aws::external::brews() {

  # base
  p6df::core::homebrew::cmd::brew tap aws/tap
  p6df::core::homebrew::cli::brew::install awscli
  p6df::core::homebrew::cli::brew::install aws-simple-ec2-cli

  # cloudformation / elastic beanstalk
  p6df::core::homebrew::cli::brew::install cloudformation-cli
  p6df::core::homebrew::cli::brew::install cfn-lint

  p6df::core::homebrew::cli::brew::install awsebcli

  # eks/ecs
  p6df::core::homebrew::cmd::brew tap weaveworks/tap
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
  p6_network_file_download "https://s3.us-west-2.amazonaws.com/amazon-eks/1.34.2/2025-11-13/bin/darwin/amd64/kubectl" "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec/aws-eks-kubectl"

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::mcp()
#
#>
######################################################################
p6df::modules::aws::mcp() {

  p6_js_npm_global_install "@imazhar101/mcp-aws-server"

  p6df::modules::anthropic::mcp::server::add "aws" "npx" "-y" "@imazhar101/mcp-aws-server"
  p6df::modules::openai::mcp::server::add "aws" "npx" "-y" "@imazhar101/mcp-aws-server"

  p6_return_void
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
  p6df::modules::vscode::extension::install kddejong.vscode-cfn-lint
  p6df::modules::vscode::extension::install loganarnett.lambda-snippets

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::vscodes::config()
#
#>
######################################################################
p6df::modules::aws::vscodes::config() {

 cat <<'EOF'
  "aws.telemetry": false,
  "cfnLint.runOnSave": true,
  "yaml.schemas": {
    "https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json": [
      "cloudformation*.yml",
      "cloudformation*.yaml",
      "**/*cfn*.yml",
      "**/*cfn*.yaml"
    ],
    "https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json": [
      "template.yml",
      "template.yaml",
      "**/*sam*.yml",
      "**/*sam*.yaml"
    ]
  }
EOF

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::profile::on(profile, code)
#
#  Args:
#	profile -
#	code -
#
#  Environment:	 P6_AWS_ORG
#>
######################################################################
p6df::modules::aws::profile::on() {
  local profile="$1"
  local code="$2"

  p6_run_code "$code"

  p6_aws_cli_organization_on "$P6_AWS_ORG"
#  p6df::modules::aws::profiles::list

  p6_return_void
}

######################################################################
#<
#
# Function: p6df::modules::aws::profile::off(code)
#
#  Args:
#	code -
#
#>
######################################################################
p6df::modules::aws::profile::off() {
  local code="$1"

  p6_env_unset_from_code "$code"

  p6_aws_cli_organization_off

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

  local orgs=$(p6_curl -s "https://aws.github.io" | p6_filter_row_select "https://github.com" | p6_filter_row_exclude "project_name" \
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
# Function: str str = p6df::modules::aws::prompt::context()
#
#  Returns:
#	str - str
#
#  Environment:	 P6_NL
#>
######################################################################
p6df::modules::aws::prompt::context() {

  local str
  local prefix=$(p6_string_space_pad "AWS:" 16)
  local active=$(p6_aws_cfg_prompt_info "_active")
  local source=$(p6_aws_cfg_prompt_info "_source")
  local saved=$(p6_aws_cfg_prompt_info "_saved")

  local sts=$(p6_aws_sts_prompt_info "$(p6_aws_env_shared_credentials_file_active)")
  local item
  for item in "$active" "$source" "$saved"; do
    if p6_string_blank_NOT "$item"; then
      str=$(p6_string_append "$str" "$prefix$item" "$P6_NL")
    fi
  done
  str=$(p6_string_append "$str" "$sts" " ")

  str=$(p6_echo "$str" | p6_filter_strip_leading_spaces)

  p6_return_str "$str"
}

