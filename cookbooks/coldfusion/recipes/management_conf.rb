rightscale_marker :begin

template "/etc/apache2/sites-available/#{node[:coldfusion][:application]}.conf" do
  source "manage-vhosts.conf.erb"
  mode 00644
  variables(
    :applicaiton => "/home/webapps/#{node[:coldfusion][:application]}"
  )
end

service "apache2" do
  action :restart
end

rightscale_marker :end
