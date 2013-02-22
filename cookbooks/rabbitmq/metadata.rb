maintainer       "SchoolSpring.com"
maintainer_email "devteam@schoolspring.com"
license          "Apache 2.0"
description      "RabbitMQ Recipes" 
version          "0.0.1"

depends "sys"

recipe "rabbitmq::create_ec2_utils.rb", "Replaces /opt/rightscale/ebs/ec2_ebs_utils.rb with increased wait time"
