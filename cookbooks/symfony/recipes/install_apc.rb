rightscale_marker :begin

case node[:platform]
when "ubuntu","debian"
  package "php-apc"
when "centos"
  package "php53-devel"
  bash "apc via pecl" do
    code <<-EOH
      pecl install apc
      echo "extension=apc.so" > /etc/php.ini
    EOH
  end
end

rightscale_marker :end
