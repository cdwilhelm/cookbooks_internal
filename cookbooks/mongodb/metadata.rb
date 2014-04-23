maintainer       "SchoolSpring, Inc."
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "MongoDB recipes" 
version          "0.0.1"

depends "sys"

recipe "mongodb::default", "Installs and configures MongoDB"
recipe "mongodb::stop", "Stops mongodb daemon"
recipe "mongodb::start", "Starts mongodb daemon"
