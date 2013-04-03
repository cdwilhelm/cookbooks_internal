rightscale_marker :begin

log "===> Installing python-pip"
case node[:platform]
when "ubuntu","debian"
  package "python-pip"
  package "python-dev"
  package "php5-dev"
when "centos"
  package "python-pip"
  package "python-devel"
  package "php53-devel"
end

log "===> Installing celery"
ruby_block "easy_install -U celery-with-redis" do
  block do
    system "easy_install -U celery-with-redis"
  end
end

log "===> Installing amqp"
ruby_block "rabbitmq-c" do
  block do
    system "git clone git://github.com/alanxz/rabbitmq-c.git"
  end
  not_if {File.exists?('/rabbitmq-c')}
end

ruby_block "rabbitmq-c" do
  block do
    system "cd rabbitmq-c"
  # Enable and update the codegen git submodule
    system "git submodule init"
    system "git submodule update"
    system "autoreconf -i && ./configure && make && make install"
  end
  not_if {File.exists?('/rabbitmq-c/install-sh')}
end

ruby_block "AMQP" do
  block do
    system "pecl install AMQP"
    system "echo 'extension=amqp.so' >> /etc/php.ini"
  end
  not_if "grep /etc/php.ini amqp.so"
end

template "/usr/lib/python2.7/celeryconfig.py" do
  source "celeryconfig.py.erb"
  variables(
    :redis_password => node[:celery][:redis_password],
    :redis_hostname => node[:celery][:redis_hostname]
  )
end

rightscale_marker :end

