maintainer       "School Spring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Symfony Recipes" 
version          "0.0.1"

depends "rightscale"
depends "block_device"
depends "web_apache"
depends "rightscale"
depends "repo_git"
depends "app_php"

recipe "symfony::install_apc", "Installs php APC"
recipe "symfony::add_vhost", "Adds a new vhost and clones repo"
recipe "symfony::update_code", "Syncs repository"
recipe "symfony::update_vendors", "Runs vendor update via composer"
recipe "symfony::configure", "Configures configurations"
recipe "symfony::redis_credentials", "Adds special CF Redis credentials"
recipe "symfony::clear_cache", "clears cache and resets permissions for symfony"
recipe "symfony::init_submodules", "adds git submodules required for symofny"

attribute "symfony/application",
    :display_name => "Application name (ssv2)",
    :description  => "Application name (ssv2)",
    :required     => "required",
    :recipes      => [ "symfony::redis_credentials", "symfony::init_submodules", "symfony::redis_credentials", "symfony::configure", "symfony::update_code", "symfony::add_vhost" ]

attribute "symfony/redis/hostname",
    :display_name => "redis hostname",
    :description  => "redis hostname",
    :required     => "required",
    :recipes      => [ "symfony::redis_credentials" ]

attribute "symfony/redis/password",
    :display_name => "redis password",
    :description  => "redis password",
    :required     => "optional",
    :recipes      => [ "symfony::redis_credentials" ]

attribute "composer/arguments",
    :display_name => "Composer Arguments",
    :description  => "Optional arguments to composer.phar update",
    :required     => "optional",
    :recipes      => [ "symfony::update_vendors" ]

attribute "amazon/key",
    :display_name => "amazon key",
    :description  => "amazon key",
    :required     => "optional",
    :recipes      => [ "symfony::redis_credentials", "symfony::add_vhost" ]

attribute "amazon/secret",
    :display_name => "amazon secret",
    :description  => "amazon secret",
    :required     => "optional",
    :recipes      => [ "symfony::redis_credentials", "symfony::add_vhost" ]

attribute "repo/default/credential",
  :display_name => "Account credential",
  :description =>
    "A valid credential (i.e. password, SSH key, account secret)" +
    " to access files in the specified location. This input is always" +
    " required for Git and Rsync but may be optional for other providers." +
    " Example: cred:RACKSPACE_AUTH_KEY",
  :required => "recommended",
  :recipes => ["repo::default"]

attribute "repo/default/ssh_host_key",
  :display_name => "Known hosts ssh key",
  :description =>
    "A valid SSH key which will be appended to /root/.ssh/known_hosts file." +
    " This input will allow to verify the destination host, by comparing its" +
    " IP,FQDN, SSH-RSA with the record in /root/.ssh/known_hosts file." +
    " Use this input if you want to improve security" +
    " and for MiTM attacks prevention. Example: cred:SSH_KNOWN_HOST_KEY.",
  :required => "optional",
  :recipes => ["repo::default"]
