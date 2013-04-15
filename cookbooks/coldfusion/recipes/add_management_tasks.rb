rightscale_marker :begin

template "/home/webapps/#{node[:coldfusion][:application]}/www/CFIDE/cftasks.cfm" do
  source "cftasks.cfm.erb"
  mode 00644
  variables(
    :cf_admin_pass => node[:coldfusion][:admin_password],
    :db_user => node[:coldfusion][:tasks][:username],
    :db_pass => node[:coldfusion][:tasks][:password]
  )
end

ruby_block "run admin api" do
  block do
    system "curl localhost:8000/CFIDE/cftasks.cfm"
  end
end


rightscale_marker :end
