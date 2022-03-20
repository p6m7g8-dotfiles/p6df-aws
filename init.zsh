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
    aws-samples/aws-lambda-layer-awscli
    aws-samples/awscli-profile-credential-helpers
    aws/aws-codebuild-docker-images
#    aws/aws-nitro-enclaves-cli
    awslabs/awscli-aliases
    opensearch-project/opensearch-cli
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
  brw install lightsailctl

  # athena
  brew install athenacli

  # iam
  brew install aws-iam-authenticator

  # logs
  brew install awslogs

  # shell/cli
  brew install aws-shell
  brew install aws-vault
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
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs::ruby()
#
#>
######################################################################
p6df::modules::aws::langs::ruby() {

  echo gem install aws-sdk
  gem install aws-sdk
  rbenv rehash
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
}

p6df::modules::aws::langs::clones() {

  local orgs=$(curl -s https://aws.github.io | grep https://github.com | grep -v project_name | sed -e 's,.*com/,,' -e 's,".*,,' -e 's,/,,' | sort)
  local org
  for org in $(p6_echo $orgs); do
    p6_github_util_org_repos_clone "$org" "$P6_DFZ_SRC_FOCUSED_DIR"
  done
}

######################################################################
#<
#
# Function: p6df::modules::aws::langs()
#
#  Environment:	 P6_DFZ_SRC_P6M7G8_DIR
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


  # clones
  p6df::modules::aws::langs::clones
}

######################################################################
#<
#
# Function: p6df::modules::aws::home::symlink()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::aws::home::symlink() {

  p6_dir_rmrf .aws
  p6_dir_mk .aws

  (
    p6_dir_cd .aws
    for file in $P6_DFZ_SRC_DIR/$USER/home-private/aws/*; do
      p6_file_symlink "$file" "."
    done

    p6_file_symlink "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/share/cli" cli
  )
}

######################################################################
#<
#
# Function: p6df::modules::aws::init()
#
#  Environment:	 P6_DFZ_SRC_DIR P6_DFZ_SRC_P6M7G8_DIR
#>
######################################################################
p6df::modules::aws::init() {

  p6df::util::path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/aws/aws-codebuild-docker-images/local_builds"
  p6df::util::path_if "$P6_DFZ_SRC_P6M7G8_DOTFILES_DIR/p6df-aws/libexec"
}

######################################################################
#<
#
# Function: p6df::modules::aws::prompt::line()
#
#  Depends:	 p6_string
#>
######################################################################
p6df::modules::aws::prompt::line() {

  p6_aws_prompt_info
}

######################################################################
#<
#
# Function: str str = p6_aws_prompt_info()
#
#  Returns:
#	str - str
#
#  Depends:	 p6_string
#>
######################################################################
p6_aws_prompt_info() {

  local active=$(p6_aws_cfg_prompt_info "_active")
  local source=$(p6_aws_cfg_prompt_info "_source")
  local saved=$(p6_aws_cfg_prompt_info "_saved")

  local sts=$(p6_aws_sts_prompt_info "$(p6_aws_env_shared_credentials_file_active)")

  local str
  local item
  for item in "$active" "$source" "$saved" "$sts"; do
    if ! p6_string_blank "$item"; then
      str=$(p6_string_append "$str" "$item" "
")
    fi
  done

  str=$(p6_echo $str | perl -p -e 's,^\s*,,')

  p6_return_str "$str"
}
