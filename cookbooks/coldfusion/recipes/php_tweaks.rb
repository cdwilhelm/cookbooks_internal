rightscale_marker :begin

package "php-apc"

execute "symfony submodules" do
 installation_dir = "/home/webapps/#{node[:coldfusion][:application]}"
 cwd installation_dir
 command "git submodule init"
 command "git submodule update"
 creates installation_dir + "/symfony/vendor/symfony"
 action :run
end

directory "/home/webapps/#{node[:coldfusion][:application]}/symfony/cache" do
  mode "777"
  recursive true
end

directory "/home/webapps/#{node[:coldfusion][:application]}/symfony/log" do
  mode "777"
  recursive true
end

rightscale_marker :end
