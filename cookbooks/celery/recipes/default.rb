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

group "celery" do
  group_name "celery"
  action :create
end

user "celery" do
  gid "celery"
  action :create
end

directory "/var/run/celery" do
  owner "root"
  group "celery"
  mode 0775
  action :create
end

directory "/var/log/celery" do
  owner "root"
  group "celery"
  mode 0775
  action :create
end

directory "/home/webapps/celery" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/home/webapps/celery/celeryconfig.py" do
  source "celeryconfig.py.erb"
  variables(
    :redis_password => node[:celery][:redis_password],
    :redis_hostname => node[:celery][:redis_hostname]
  )
end

cookbook_file "/etc/default/celeryd" do
  source "celeryd.conf"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/etc/init.d/celeryd" do
  source "celeryd"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/home/webapps/celery/visit.py" do
  source "visit.py"
  mode 0755
  owner "root"
  group "root"
end

service "celeryd" do
  action :start
end

rightscale_marker :end

