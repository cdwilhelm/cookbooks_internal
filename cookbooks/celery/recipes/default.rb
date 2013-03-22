rightscale_marker :begin

log "===> Installing python-pip"
package "python-pip"
package "python-dev"
package "php-dev"

log "===> Installing celery"
ruby_block "easy_install -U celery-with-redis" do
  block do
    system "easy_install -U celery-with-redis"
  end
end

log "===> daemonizing celery"
cookbook_file "/etc/init.d/celeryd" do
  source "celeryd"
  owner "root"
  group "root"
  mode "0755"
end

log "===> Installing amqp"
ruby_block "AMQP" do
  block do
    system "git clone git://github.com/alanxz/rabbitmq-c.git"
    system "cd rabbitmq-c"
  # Enable and update the codegen git submodule
    system "git submodule init"
    system "git submodule update"
    system "autoreconf -i && ./configure && make && sudo make install"
    system "sudo pecl install AMQP"
    system "echo 'extension=amqp.so' >> /etc/php.ini"
  end
end

template "/usr/lib/python2.6/celeryconfig.py" do
  source "celeryconfig.py.erb"
  variables(
    :redis_password => node[:celery][:redis_password],
    :redis_hostname => node[:celery][:redis_hostname]
  )
end

rightscale_marker :end

