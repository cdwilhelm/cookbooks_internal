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

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}/symfony2/"
  command "rm composer.lock"
  command "php composer.phar install --prefer-dist --dev"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/symfony2/composer.phar") }
  action :run
end

execute "clear_cache" do
  cwd "/home/webapps/#{node[:web_app][:application]}/symfony2/"
  command "app/console cache:clear --env=prod"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}/symfony2/app/console") }
  action :run
end

rightscale_marker :end
