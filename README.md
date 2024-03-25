# p6df-aws

## Table of Contents


### p6df-aws
- [p6df-aws](#p6df-aws)
  - [Badges](#badges)
  - [Distributions](#distributions)
  - [Summary](#summary)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Usage](#usage)
  - [Author](#author)

### Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6df-aws)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6df-aws/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6df-aws/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6df-aws)
[![Gihub repo dependents](https://badgen.net/github/dependents-repo/p6m7g8/p6df-aws)](https://github.com/p6m7g8/p6df-aws/network/dependents?dependent_type=REPOSITORY)
[![Gihub package dependents](https://badgen.net/github/dependents-pkg/p6m7g8/p6df-aws)](https://github.com/p6m7g8/p6df-aws/network/dependents?dependent_type=PACKAGE)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](https://github.com/p6m7g8/.github/blob/master/CODE_OF_CONDUCT.md)

## Usage


### Aliases


### Functions

### p6df-aws:

#### p6df-aws/init.zsh:

- p6df::modules::aws::deps()
- p6df::modules::aws::env::prompt::info()
- p6df::modules::aws::external::brew()
- p6df::modules::aws::home::symlink()
- p6df::modules::aws::home::symlink::creds()
- p6df::modules::aws::init(_module, dir)
- p6df::modules::aws::langs()
- p6df::modules::aws::langs::clones()
- p6df::modules::aws::langs::go()
- p6df::modules::aws::langs::js()
- p6df::modules::aws::langs::python()
- p6df::modules::aws::langs::ruby()
- p6df::modules::aws::langs::rust()
- p6df::modules::aws::vscodes()
- str str = p6df::modules::aws::prompt::line()


### p6df-aws/lib:

#### p6df-aws/lib/sso.sh:

- p6df::modules::aws::sso::console()
- p6df::modules::aws::sso::login()
- p6df::modules::aws::sso::populate()


### svc:

#### svc/ec2.sh:

- p6df::modules::aws::svc::ec2::instances::list()
- p6df::modules::aws::svc::ec2::nat::gateway::show()
- p6df::modules::aws::svc::ec2::network::init::list()
- p6df::modules::aws::svc::ec2::rtb::show()
- p6df::modules::aws::svc::ec2::rtbs::list()
- p6df::modules::aws::svc::ec2::sg::id_from_tag_name()
- p6df::modules::aws::svc::ec2::sg::show(security_group_id)
- p6df::modules::aws::svc::ec2::sgs::list()
- p6df::modules::aws::svc::ec2::subnet::get()
- p6df::modules::aws::svc::ec2::subnetids::get()
- p6df::modules::aws::svc::ec2::subnets::list()

#### svc/eks.sh:

- p6df::modules::aws::svc::eks::cluster::find()
- p6df::modules::aws::svc::eks::cluster::set(cluster_name)
- p6df::modules::aws::svc::eks::cluster::set(cluster_name)
- p6df::modules::aws::svc::eks::cluster::status()



## Hier
```text
.
├── sso.sh
└── svc
    ├── ec2.sh
    └── eks.sh

2 directories, 3 files
```
## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
