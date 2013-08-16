maintainer       "School Spring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Celery recipes" 
version          "0.0.1"

depends "sys"

recipe "celery::default", "Installs and configures Celery and AMQP"
recipe "celery::stop_worker", "Stops celery daemon"
recipe "celery::start_worker", "Starts celery daemon"
recipe "celery::start_celery", "Depricated"
recipe "cllery::stop_celery", "Depricated"

attribute "celery/redis_hostname",
    :display_name => "Redis Hostname",
    :description  => "Redis Hostname",
    :required     => "required",
    :recipes      => [ "celery::default" ]

attribute "celery/redis_password",
    :display_name => "Redis Password",
    :description  => "Redis Password",
    :recipes      => [ "celery::default" ]
