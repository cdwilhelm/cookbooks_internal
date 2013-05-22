rightscale_marker :begin

template "/home/webapps/#{node[:coldfusion][:application]}/includes/www/logic/redis.cfm" do
  source "redis.cfm.erb"
  mode 00644
  variables(
    :loc => node[:glusterfs][:volume_name],
    :hostname => node[:coldfusion][:redis][:hostname],
    :password => node[:coldfusion][:redis][:password]
  )
end

template "/home/webapps/#{node[:coldfusion][:application]}/includes/www/logic/aws.cfm" do
  source "aws.cfm.erb"
  mode 00644
end

rightscale_marker :end
