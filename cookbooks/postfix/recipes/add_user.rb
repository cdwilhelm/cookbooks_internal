require 'json'

rightscale_marker :begin

users = JSON.decode(node[:postfix][:users])
users.each do | username, options |
  if v.has_key?("shell")
    shell = "-s #{v['shell']}"
  else
    shell = "-s /sbin/nologin"
  end
  execute "useradd" do
   command "useradd #{shell} #{username}"
   creates "/home/#{username}"
  end
  template "/home/#{username}/.forward" do
    source "forward.erb"
    variables(
      :deploy_dir => node[:postfix][:deploy_dir],
      :username => username
    )
  end
end


include_recipe "postfix::restart"

rightscale_marker :end
