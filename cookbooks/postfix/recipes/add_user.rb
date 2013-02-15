require 'json'

rightscale_marker :begin

users = JSON.parse(node[:postfix][:users])
users.each do | username, options |
  if options.has_key?("shell")
    shell = "-s #{v['shell']}"
  else
    shell = "-s /sbin/nologin"
  end
  execute "useradd" do
   command "useradd -m #{shell} #{username}"
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

rightscale_marker :end
