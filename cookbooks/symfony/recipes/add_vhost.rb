require "rubygems"
require "json"

rightscale_marker :begin

node[:web_app] = JSON.parse(node[:web_app_config])

RightScale::Repo::GitSshKey.new.create(node[:repo][:default][:credential], node[:repo][:default][:credential] )


log "===> Cloning resource"
git "/home/webapps/#{node[:web_app][:application]}" do
  repository node[:web_app][:git_repository]
  reference node[:web_app][:git_revision]
  enable_submodules node[:web_app][:submodule_init]
  action :sync
end

execute "htpasswd" do
  command "htpasswd -b -c /home/webapps/#{node[:web_app][:application]}/.htpasswd #{node[:web_app][:htpasswd][:username]} #{node[:web_app][:htpasswd][:password]}"
  action :run
end

package "python-software-properties" do
  action :install
end

#todo test the version
package "php5" do
  action :remove
end

execute "touch_apt_list" do
  command "touch /etc/apt/sources.list"
  action :run
end

apt_repository "nodejs" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C7917B12"
end
apt_repository "php5_4" do
  uri "http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
end
execute "php_add_package" do
  command "apt-get update"
  action :run
end

package "php5" do
  action :install
end

package "php5-curl" do
  action :install
end

package "acl" do
  action :install
end

execute "add acl to mount" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}"
  command "sed 's/barrier=0/barrier=0,acl/' -i /etc/fstab"
  command "mount -o remount /"
  command "mkdir -p /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/cache"
  command "mkdir -p /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/logs"
  command "setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/cache /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/logs"
  command "setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/cache /home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/logs"
  action :run
end

package "php5-intl" do
  action :upgrade
end

package "default-jre" do
  action :install
end

package "nodejs" do
  action :remove
end

package "nodejs" do
  action :install
end

execute "node_less" do
  command "npm install -g less"
  action :run
end

template "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}app/config/parameters.yml" do
  source "parameters.yml.erb"
  mode "0644"
  variables(
    :hostname => node[:web_app][:database][:hostname],
    :username => node[:web_app][:database][:username],
    :password => node[:web_app][:database][:password],
    :mailer_hostname => node[:coldfusion][:mail][:server],
    :redis_hostname => node[:symfony][:redis][:hostname],
    :aws_key => node[:amazon][:key],
    :aws_secret => node[:amazon][:secret],
    :file_path => node[:web_app][:file_path],
    :schema_name => node[:web_app][:database][:schema_name]
  )
end

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}/"
  command "php composer.phar install  --optimize-autoloader"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}composer.phar") }
  action :run
end

execute "clear_cache" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}/"
  command "app/console cache:clear --env=prod"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}/app/console") }
  action :run
end


if node[:web_app].has_key?("htpasswd")
  execute "htpasswd" do 
    command "htpasswd -c -b /home/webapps/#{node[:web_app][:application]}/.htpasswd #{node[:web_app][:htpasswd][:username]} #{node[:web_app][:htpasswd][:username]}"
  end
end


log "===> Creating vhost"
template "/etc/apache2/sites-available/#{node[:web_app][:application]}.conf" do
  source "vhost.conf.erb"
  variables(
    :hostname => node[:web_app][:hostname],
    :application => node[:web_app][:application],
    :web_root => node[:web_app][:web_root]
  )
end

log "===> Linking vhost"
link "/etc/apache2/sites-enabled/#{node[:web_app][:application]}.conf" do
  to "/etc/apache2/sites-available/#{node[:web_app][:application]}.conf"
end

execute "restart_apache" do
  command "apache2ctl restart"
  action :run
end


rightscale_marker :end
