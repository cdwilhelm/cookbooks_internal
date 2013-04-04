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

rightscale_marker :end
