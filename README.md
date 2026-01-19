# P6's POSIX.2: p6df-aws

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-aws

##### p6df-aws/init.zsh

- `p6df::modules::aws::deps()`
- `p6df::modules::aws::external::brew()`
- `p6df::modules::aws::home::symlink()`
- `p6df::modules::aws::home::symlink::creds()`
- `p6df::modules::aws::init(_module, dir)`
- `p6df::modules::aws::langs()`
- `p6df::modules::aws::langs::clones()`
- `p6df::modules::aws::langs::go()`
- `p6df::modules::aws::langs::js()`
- `p6df::modules::aws::langs::python()`
- `p6df::modules::aws::langs::ruby()`
- `p6df::modules::aws::langs::rust()`
- `p6df::modules::aws::vscodes()`
- `str str = p6df::modules::aws::prompt::mod()`
- `stream  = p6df::modules::aws::profiles::list()`

#### p6df-aws/lib

##### p6df-aws/lib/sso.sh

- `p6df::modules::aws::sso::console()`
- `p6df::modules::aws::sso::login()`
- `p6df::modules::aws::sso::populate()`

#### svc

##### p6df-aws/lib/svc/ec2.sh

- `p6df::modules::aws::svc::ec2::instances::list()`
- `p6df::modules::aws::svc::ec2::nat::gateway::show()`
- `p6df::modules::aws::svc::ec2::network::init::list()`
- `p6df::modules::aws::svc::ec2::rtb::show()`
- `p6df::modules::aws::svc::ec2::rtbs::list()`
- `p6df::modules::aws::svc::ec2::sg::id_from_tag_name()`
- `p6df::modules::aws::svc::ec2::sg::show(security_group_id)`
- `p6df::modules::aws::svc::ec2::sgs::list()`
- `p6df::modules::aws::svc::ec2::subnet::get()`
- `p6df::modules::aws::svc::ec2::subnetids::get()`
- `p6df::modules::aws::svc::ec2::subnets::list()`

##### p6df-aws/lib/svc/eks.sh

- `p6df::modules::aws::svc::eks::cluster::find()`
- `p6df::modules::aws::svc::eks::cluster::set(cluster_name)`
- `p6df::modules::aws::svc::eks::cluster::set(cluster_name)`
- `p6df::modules::aws::svc::eks::cluster::status()`

## Hierarchy

```text
.
├── init.zsh
├── lib
│   ├── sso.sh
│   └── svc
│       ├── ec2.sh
│       └── eks.sh
├── libexec
├── README.md
└── share

5 directories, 5 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
