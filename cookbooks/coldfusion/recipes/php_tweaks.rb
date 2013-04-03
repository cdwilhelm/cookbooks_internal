rightscale_marker :begin

case node[:platform]
when "ubuntu","debian"
  package "php-apc" do
    action :install
  end
when "centos"
  package "php53-devel"
  package "php-pecl-apc"
end

bash "symfony submodules" do
 installation_dir = "/home/webapps/#{node[:coldfusion][:application]}"
 cwd installation_dir
 code <<-EOF
   git submodule init
   git submodule update
 EOF
 creates installation_dir + "/symfony/lib/vendor/symfony/LICENSE"
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
