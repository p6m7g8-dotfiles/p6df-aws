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
  brew install aws-iam-authenticator
  brew install aws-sso-cli

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

# athenacli: CLI tool for AWS Athena service
# aws-auth: Allows you to programmatically authenticate into AWS accounts through IAM roles
# aws-cdk: AWS Cloud Development Kit - framework for defining AWS infra as code
# aws-console: Command-line to use AWS CLI credentials to launch the AWS console in a browser
# aws-es-proxy: Small proxy between HTTP client and AWS Elasticsearch
# aws-google-auth: Acquire AWS credentials using Google Apps
# aws-iam-authenticator: Use AWS IAM credentials to authenticate to Kubernetes
# aws-keychain: Uses macOS keychain for storage of AWS credentials
# aws-nuke: Nuke a whole AWS account and delete all its resources
# aws-okta: Authenticate with AWS using your Okta credentials
# aws-rotate-key: Easily rotate your AWS access key
# aws-sam-cli: CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM
# aws-sdk-cpp: AWS SDK for C++
# aws-shell: Integrated shell for working with the AWS CLI
# aws-sso-util: Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)
# aws-vault: Securely store and access AWS credentials in development environments
# aws/tap/aws-sam-cli: AWS SAM CLI 🐿 is a tool for local development and testing of Serverless applications
# aws-sam-cli-beta-cdk: AWS SAM CLI 🐿 is a tool for local development and testing of Serverless applications. This is a pre-release version of AWS SAM CLI
# aws-sam-cli-nightly: AWS SAM CLI 🐿 is a tool for local development and testing of Serverless applications. This is a pre-release version of AWS SAM CLI
# aws-sam-cli-rc: AWS SAM CLI 🐿 is a tool for local development and testing of Serverless applications
# aws-simple-ec2-cli: AWS Simple EC2 CLI is a tool that simplifies the process of launching, connecting and terminating an EC2 instance
# container-tools: Meta Package for common AWS Container tools
# copilot-cli: Copilot CLI - build, release and operate your container apps on AWS
# xray-daemon: The AWS X-Ray daemon listens for traffic on UDP port 2000, gathers raw segment data, and relays it to the AWS X-Ray API.
# aws2-wrap: Script to export current AWS SSO credentials or run a sub-process with them
# awscli: Official Amazon AWS command-line interface
# awscli@1: Official Amazon AWS command-line interface
# awscurl: Curl like simplicity to access AWS resources
# awslogs: Simple command-line tool to read AWS CloudWatch logs
# awsume: Utility for easily assuming AWS IAM roles from the command-line
# awsweeper: CLI tool for cleaning your AWS account
# cfn-flip: Convert AWS CloudFormation templates between JSON and YAML formats
# cfn-format: Command-line tool for formatting AWS CloudFormation templates
# chamber: CLI for managing secrets through AWS SSM Parameter Store
# clusterawsadm: Home for bootstrapping, AMI, EKS, and other helpers in Cluster API Provider AWS
# copilot: CLI tool for Amazon ECS and AWS Fargate
# fargatecli: CLI for AWS Fargate
# gimme-aws-creds: CLI to retrieve AWS credentials from Okta
# git-remote-codecommit: Git Remote Helper to interact with AWS CodeCommit
# goad: AWS Lambda powered, highly distributed, load testing tool built in Go
# consul-aws: Consul AWS
# iamy: AWS IAM import and export tool
# kube-aws: Command-line tool to declaratively manage Kubernetes clusters on AWS
# localstack: Fully functional local AWS cloud stack
# moto: Mock AWS services
# msc-generator: Draws signalling charts from textual description
# okta-awscli: Okta authentication for awscli
# parliament: AWS IAM linting library
# principalmapper: Quickly evaluate IAM permissions in AWS
# rain: Command-line tool for working with AWS CloudFormation
# rosa-cli: RedHat OpenShift Service on AWS (ROSA) command-line interface
# saml2aws: Login and retrieve AWS temporary credentials using a SAML IDP
# sceptre: Build better AWS infrastructure
# sha3sum: Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities
# sqsmover: AWS SQS Message mover
# terraforming: Export existing AWS resources to Terraform style (tf, tfstate)
# testssl: Tool which checks for the support of TLS/SSL ciphers and flaws
# trailscraper: Tool to get valuable information out of AWS CloudTrail
 
# 7777: (7777) Remote AWS database on local port 7777
# aws-vault: (aws-vault) Securely stores and accesses AWS credentials in a development environment
# aws-vpn-client: (AWS Client VPN) Managed client-based VPN service to securely access AWS resources
# corretto: (AWS Corretto JDK) OpenJDK distribution from Amazon
# corretto11: (AWS Corretto JDK) OpenJDK distribution from Amazon
# corretto17: (AWS Corretto JDK) OpenJDK distribution from Amazon
# dia: (Dia) Draw structured diagrams
# elasticwolf: (AWS ElasticWolf Client Console) Manage Amazon Web Services (AWS) cloud resources
# honer: (Honer) Utility that draws a border around the focused window
# session-manager-plugin: (Session Manager Plugin for the AWS CLI) Plugin for AWS CLI to start and end sessions that connect to managed instances
# skychart: (SkyChart, Cartes du Ciel) Draw sky charts
# storyboarder: (Wonder Unit Storyboarder) Visualize a story as fast you can draw stick figures

# amazon-ecs-cli: CLI for Amazon ECS to manage clusters and tasks for development
# aws-cfn-tools: Client for Amazon CloudFormation web service
# aws-elasticbeanstalk: Client for Amazon Elastic Beanstalk web service
# ec2-spot-interrupter: A simple CLI tool that triggers Amazon EC2 Spot Interruption Notifications and Rebalance Recommendations.
# eksdemo: The easy button for learning, testing and demoing Amazon EKS
# emr-on-eks-custom-image: Amazon EMR on EKS Custom Image CLI
# lightsailctl: Amazon Lightsail CLI Extensions
# awscli: Official Amazon AWS command-line interface
# awscli@1: Official Amazon AWS command-line interface
# clamz: Download MP3 files from Amazon's music store
# cli53: Command-line tool for Amazon Route 53
# cloud-watch: Amazon CloudWatch command-line Tool
# copilot: CLI tool for Amazon ECS and AWS Fargate
# docker-credential-helper-ecr: Docker Credential Helper for Amazon ECR
# ec2-ami-tools: Amazon EC2 AMI Tools (helps bundle Amazon Machine Images)
# ec2-api-tools: Client interface to the Amazon EC2 web service
# eksctl: Simple command-line tool for creating clusters on Amazon EKS
# elb-tools: Client interface to the Amazon Elastic Load Balancing web service
# goofys: Filey-System interface to Amazon S3
# rds-command-line-tools: Amazon RDS command-line toolkit
# s3-backer: FUSE-based single file backing store via Amazon S3
# s3cmd: Command-line tool for the Amazon S3 service
# s3fs: FUSE-based file system backed by Amazon S3
# weaveworks/tap/eksctl: The official CLI for Amazon EKS
# eksctl-private: The official CLI for Amazon EKS
 
# amazon-chime: (Amazon Chime) Communications service
# amazon-luna: (Amazon Luna) Play your favorite games straight from the cloud
# amazon-music: (Amazon Music) Desktop client for Amazon Music
# amazon-photos: (Amazon Drive, Amazon Photos) Photo storage and sharing service
# amazon-workdocs: (Amazon WorkDocs) Fully managed, secure content creation, storage, and collaboration service
# amazon-workdocs-drive: (Amazon WorkDocs Drive) Fully managed, secure enterprise storage and sharing service
# amazon-workspaces: (Amazon Workspaces) Cloud native persistent desktop virtualization
# corretto: (AWS Corretto JDK) OpenJDK distribution from Amazon
# corretto11: (AWS Corretto JDK) OpenJDK distribution from Amazon
# corretto17: (AWS Corretto JDK) OpenJDK distribution from Amazon
# corretto8: (Amazon Corretto JDK) OpenJDK distribution from Amazon
# dynamodb-local: (Amazon DynamoDB Local) [no description]
# elasticwolf: (AWS ElasticWolf Client Console) Manage Amazon Web Services (AWS) cloud resources
# forklift: (ForkLift) Finder replacement and FTP, SFTP, WebDAV and Amazon s3 client
# forklift2: (ForkLift) Finder replacement and FTP, SFTP, WebDAV and Amazon s3 client
# freeze: (Freeze) Amazon Glacier file transfer client
