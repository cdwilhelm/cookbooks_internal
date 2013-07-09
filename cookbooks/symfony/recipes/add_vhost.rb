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

package "python-software-properties" do
  action :install
end

execute "php_add_package" do
  command "add-apt-repository ppa:ondrej/php5"
  command "add-apt-repository ppa:chris-lea/node.js"
  command "apt-get update"
  action :run
end

package "php5" do
  action :upgrade
end

package "php5-curl" do
  action :install
end

package "acl" do
  action :install
end

execute "add acl to mount" do
  cwd "/home/webapps/#{node[:web_app][:application]}/symfony2/"
  command "sed 's/barrier=0/barrier=0,acl/' -i /etc/fstab"
  command "mount -o remount /"
  command "setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs"
  command "setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs"
  action :run
end

package "nodejs" do
  action :install
end

execute "node_less" do
  command "npm install -g less"
  action :run
end

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}/symfony2/"
  command "rm composer.lock"
  command "php composer.phar install"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/symfony2/composer.phar") }
  action :run
end

execute "clear_cache" do
  cwd "/home/webapps/#{node[:web_app][:application]}/symfony2/"
  command "app/console cache:clear --env=prod"
  command "app/console assets:install --env=prod"
  command "app/console assetic:dump --env=prod"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/symfony2/app/console") }
  action :run
end


if node[:web_app].has_key?("htpasswd")
  execute "htpasswd" do 
    command "htpasswd -c -b /home/webapps/#{node[:web_app][:application]}/.htpasswd #{node[:web_app][:htpasswd][:username]} #{node[:web_app][:htpasswd][:username]}"
  end
end
template "/home/webapps/#{node[:web_app][:application]}/symfony2/app/config/parameters.yml" do
  source "parameters.yml.erb"
  variables(
    :hostname => node[:web_app][:database][:hostname],
    :username => node[:web_app][:database][:username],
    :password => node[:web_app][:database][:password],
    :schema_name => node[:web_app][:database][:schema_name]
  )
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
