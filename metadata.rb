name 'consul-template'
maintainer 'Bittopaz'
maintainer_email 'topaz.zhong@gmail.com'
license 'Apache-2.0'
description 'Installs and configures consul-template daemon'
version '0.0.1'
source_url 'https://github.com/bittopaz/chef-consul-template'
issues_url 'https://github.com/bittopaz/chef-consul-template/issues'

chef_version '~> 12'
chef_version '~> 13'

depends 'ubuntu'
depends 'apt'
depends 'chef-sugar'
depends 'ark'

supports 'ubuntu', '>= 15.04'
supports 'debian', '>= 8.0'
