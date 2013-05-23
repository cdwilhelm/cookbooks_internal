rightscale_marker :begin

package "lftp"

template "/home/webapps/#{node[:coldfusion][:application]}/www/CFIDE/cftasks.cfm" do
  source "cftasks.cfm.erb"
  mode 00644
  variables(
    :cf_admin_pass => node[:coldfusion][:admin_password],
    :username => node[:coldfusion][:tasks][:username],
    :password => node[:coldfusion][:tasks][:password]
  )
end

ruby_block "run tasks api" do
  block do
    system "curl localhost:8000/CFIDE/cftasks.cfm"
  end
end


rightscale_marker :end
