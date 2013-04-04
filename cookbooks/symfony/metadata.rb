maintainer       "School Spring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Symfony Recipes" 
version          "0.0.1"

depends "rightscale"
depends "block_device"
depends "web_apache"

recipe "symfony::install_apc", "Installs php APC"
recipe "symfony::redis_credentials", "Adds special CF Redis credentials"
recipe "symfony::clear_cache", "clears cache and resets permissions for symfony"
recipe "symfony::init_submodules", "adds git submodules required for symofny"

attribute "symfony/application",
    :display_name => "Application name (ssv2)",
    :description  => "Application name (ssv2)",
    :required     => "required",
    :recipes      => [ "symfony::redis_credentials", "symfony::php_tweaks" ]

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
