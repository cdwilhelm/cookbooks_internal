rightscale_marker :begin

template "/home/webapps/#{node[:coldfusion][:application]}/includes/www/logic/redis.cfm" do
  source "redis.cfm.erb"
  variables(
    :hostname => node[:coldfusion][:redis][:hostname],
    :password => node[:coldfusion][:redis][:password]
  )
end

template "/home/webapps/#{node[:coldfusion][:application]}/symfony/config/redis.yml" do
  source "redis.yml.erb"
  variables(
    :hostname => node[:coldfusion][:redis][:hostname],
    :password => node[:coldfusion][:redis][:password]
  )
end
rightscale_marker :end
