require "rubygems"
require "json"

rightscale_marker :begin

node[:web_app] = JSON.parse(node[:web_app_config])

RightScale::Repo::GitSshKey.new.create(node[:repo][:default][:credential], node[:repo][:default][:credential] )

execute "composer_install" do
  cwd "/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}"
  command "pwd"
  command "php composer.phar update #{node[:composer][:arguments]}"
  only_if { ::File.exists?("/home/webapps/#{node[:web_app][:application]}#{node[:web_app][:symfony_dir]}composer.phar") }
  action :run
end

rightscale_marker :end
