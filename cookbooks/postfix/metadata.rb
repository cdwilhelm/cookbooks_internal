maintainer       "SchoolSpring.com"
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Postfix Recipes" 
version          "0.0.2"

depends "repo"
depends "app"
depends "sys"

recipe "postfix::add_user", "Adds a set of users"
recipe "postfix::clone_mailscripts", "Clones mailscript repository"
recipe "postfix::configure", "Configures Postfix"
recipe "postfix::restart", "Restarts Postfix"

attribute "postfix/destinations",
    :display_name => "Postfix Destinations",
    :description  => "The list of domains that are delivered via the $local_transport mail delivery transport. By default this is the Postfix local(8) delivery agent which looks up all recipients in /etc/passwd and /etc/aliases. The SMTP server validates recipient addresses with $local_recipient_maps and rejects non-existent recipients. See also the local domain class in the ADDRESS_CLASS_README file.  
The default mydestination value specifies names for the local machine only. On a mail domain gateway, you should also include $mydomain.  
The $local_transport delivery method is also selected for mail addressed to user@[the.net.work.address] of the mail system (the IP addresses specified with the inet_interfaces and proxy_interfaces parameters).",
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/dkim_key",
    :display_name => "DKIM Key",
    :description  => 'DKIM Private Key',
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

attribute "postfix/gc_username",
    :display_name => "Globalclassroom.com username",
    :description  => 'username for Globalclassroom',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/gc_password",
    :display_name => "Globalclassroom.com password",
    :description  => 'password for Globalclassroom',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/db_name",
    :display_name => "Database name",
    :description  => 'Name of the mysql database for mailscripts',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/db_host",
    :display_name => "Database hostname",
    :description  => 'Hostname of the mysql database for mailscripts',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/db_user",
    :display_name => "Database username",
    :description  => 'username for the mysql database for mailscripts',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/db_pass",
    :display_name => "Database password",
    :description  => 'password for the mysql database for mailscripts',
    :required     => "required",
    :recipes      => [ "postfix::configure" ]

attribute "postfix/users",
    :display_name => "A list of user accounts (JSON)",
    :description  => 'A well formed JSON array: {"username":{"option_name":"option_value"},"username2"...}',
    :required     => "required",
    :recipes      => [ "postfix::add_user" ]
