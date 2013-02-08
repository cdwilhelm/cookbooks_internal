maintainer       "SchoolSpring.com"
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Postfix Recipes" 
version          "0.0.1"

depends "repo"
depends "app_php"
depends "sys"

recipe "glusterfs::add_user", "Adds a set of users"
recipe "glusterfs::clone_mailscripts", "Clones mailscript repository"
recipe "glusterfs::configure", "Configures Postfix"
recipe "glusterfs::restart", "Restarts Postfix"

attribute "postfix/destinations",
    :display_name => "Postfix Destinations",
    :description  => "The list of domains that are delivered via the $local_transport mail delivery transport. By default this is the Postfix local(8) delivery agent which looks up all recipients in /etc/passwd and /etc/aliases. The SMTP server validates recipient addresses with $local_recipient_maps and rejects non-existent recipients. See also the local domain class in the ADDRESS_CLASS_README file.  
The default mydestination value specifies names for the local machine only. On a mail domain gateway, you should also include $mydomain.  
The $local_transport delivery method is also selected for mail addressed to user@[the.net.work.address] of the mail system (the IP addresses specified with the inet_interfaces and proxy_interfaces parameters).",
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/networks",
    :display_name => "Postfix Networks",
    :description  => 'The list of "trusted" remote SMTP clients that have more privileges than "strangers".',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/deploy_dir",
    :display_name => "Deployment Directory",
    :description  => 'Path of where to deploy the scripts',
    :required     => "optional",
    :default      => "/usr/local/share/mailscripts",
    :recipes      => [ "postfix::clone_mailscripts" ]

attribute "postfix/repository",
    :display_name => "Deployment Repository URL",
    :description  => 'Repository url or mailscripts',
    :required     => "required",
    :recipes      => [ "postfix::clone_mailscripts" ]

attribute "postfix/users",
    :display_name => "A list of user accounts (JSON)",
    :description  => 'A well formed JSON array: {"username":{"option_name":"option_value"},"username2"...}',
    :required     => "required",
    :recipes      => [ "postfix::add_user" ]
