rightscale_marker :begin

template "/home/webapps/#{node[:symfony][:application]}/symfony/config/redis.yml" do
  source "redis.yml.erb"
  mode 00644
  variables(
    :hostname => node[:symfony][:redis][:hostname],
    :password => node[:symfony][:redis][:password]
  )
end

rightscale_marker :begin
