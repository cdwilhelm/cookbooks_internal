maintainer       "School Spring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "Celery recipes" 
version          "0.0.1"

recipe "celery::default", "Installs and configures Celery and AMQP"
recipe "celery::start_celery", "Starts celery daemon"
recipe "cllery::stop_celery", "Stopscelery daemon"

attribute "celery/redis_hostname",
    :display_name => "Redis Hostname",
    :description  => "Redis Hostname",
    :required     => "required",
    :recipes      => [ "celery::default" ]

attribute "celery/redis_password",
    :display_name => "Redis Password",
    :description  => "Redis Password",
    :recipes      => [ "celery::default" ]
