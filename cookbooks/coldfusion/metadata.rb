maintainer       "School Spring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "ColdFusion Recipes" 
version          "0.1.0"

depends "rightscale"
depends "block_device"
depends "glusterfs"
depends "web_apache"

recipe "coldfusion::install", "Installs Coldfusion"
recipe "coldfusion::plugins", "Adds Redis support"
recipe "coldfusion::setup_monitoring", "Adds collectd monitoring task"
recipe "coldfusion::garbage_collect", "Runs garbage collection"
recipe "coldfusion::add_management_tasks", "Adds tasks for manage"
recipe "coldfusion::redis_credentials", "Adds special CF Redis credentials"
recipe "coldfusion::configure", "Runs CFAdmin API settings"
recipe "coldfusion::management_conf", "Installs vhosts for manage"
recipe "coldfusion::wsconfig", "runs Wsconfig"
recipe "coldfusion::start", "Starts Coldfusion"
recipe "coldfusion::stop", "Stops Coldfusion"
recipe "coldfusion::restart", "Restarts Coldfusion"

attribute "coldfusion/mail/server",
    :display_name => "mailserver hostname",
    :description  => "Hostname of the SMTP server",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/s3/file_prefix",
    :display_name => "Coldfusion bin",
    :description  => "File name of coldfusion bin installer",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/s3/dl_bucket",
    :display_name => "S3 Bucket Name",
    :description  => "S3 Bucket where coldfusion bin installer lives",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/s3/dl_file",
    :display_name => "S3 File Name",
    :description  => "S3 coldfusion bin file",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/amazon/aws_key",
    :display_name => "Amazon AWS key id",
    :description  => "Amazon AWS key id",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/amazon/aws_secret",
    :display_name => "Amazon AWS secret access key",
    :description  => "Amazon AWS secret access key",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/serial_number",
    :display_name => "Coldfusion current serial number",
    :description  => "Coldfusion current serial number",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/previous_serial",
    :display_name => "Coldfusion previous serial number",
    :description  => "Coldfusion previous serial number",
    :required     => "required",
    :recipes      => [ "coldfusion::install" ]

attribute "coldfusion/tasks/username",
    :display_name => "CF Tasks username ",
    :description  => "Coldfusion Tasks Username",
    :required     => "required",
    :recipes      => [ "coldfusion::add_management_tasks", "coldfusion::configure", "coldfusion::garbage_collect" ]

attribute "coldfusion/tasks/password",
    :display_name => "CF Tasks password ",
    :description  => "Coldfusion Tasks Password",
    :required     => "required",
    :recipes      => [ "coldfusion::add_management_tasks", "coldfusion::configure", "coldfusion::garbage_collect" ]

attribute "coldfusion/admin_password",
    :display_name => "CF Admin password",
    :description  => "Coldfusion Administrator Password",
    :required     => "required",
    :recipes      => [ "coldfusion::install", "coldfusion::configure" ]

attribute "coldfusion/application",
    :display_name => "Application name (ssv2)",
    :description  => "Application name (ssv2)",
    :required     => "required",
    :recipes      => [ "coldfusion::redis_credentials", "coldfusion::install", "coldfusion::configure", "coldfusion::management_conf" ]

attribute "coldfusion/redis/hostname",
    :display_name => "redis hostname",
    :description  => "redis hostname",
    :required     => "required",
    :recipes      => [ "coldfusion::redis_credentials" ]

attribute "coldfusion/redis/password",
    :display_name => "redis password",
    :description  => "redis password",
    :required     => "optional",
    :recipes      => [ "coldfusion::redis_credentials" ]

attribute "coldfusion/db/hostname",
    :display_name => "Database hostname",
    :description  => "Fully Qualified Domain for Database",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/db/username",
    :display_name => "Database username",
    :description  => "DB Username",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/db/password",
    :display_name => "Database password",
    :description  => "DB password",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/db/master_schema",
    :display_name => "Database master schema",
    :description  => "DB master schema",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/db/multi_schema",
    :display_name => "Database multi schema",
    :description  => "DB multi schema",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]

attribute "coldfusion/db/stats_schema",
    :display_name => "Database status schema",
    :description  => "DB status schema",
    :required     => "required",
    :recipes      => [ "coldfusion::configure" ]
