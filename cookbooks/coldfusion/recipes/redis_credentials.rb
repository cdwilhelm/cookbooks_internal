rightscale_marker :begin

require 'YAML'

puts YAML::dump(node)

template "/home/webapps/#{node[:coldfusion][:application]}/includes/www/logic/redis.cfm" do
  source "redis.cfm.erb"
  variables(
    :hostname => node[:coldfusion][:redis][:hostname],
    :password => node[:coldfusion][:redis][:password]
  )
end

rightscale_marker :end
