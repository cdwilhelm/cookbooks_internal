rightscale_marker :begin

template "/home/webapps/#{node[:coldfusion][:application]}/www/CFIDE/cfadmin.cfm" do
  source "cfadmin.cfm.erb"
  mode 00644
  variables(
    :cf_admin_pass => node[:coldfusion][:admin_password],
    :hostname => node[:coldfusion][:db][:hostname],
    :db_user => node[:coldfusion][:db][:username],
    :db_pass => node[:coldfusion][:db][:password],
    :master_schema => node[:coldfusion][:db][:master_schema],
    :multi_schema => node[:coldfusion][:db][:multi_schema],
    :stats_schema => node[:coldfusion][:db][:stats_schema],
    :webroot => "/home/webapps/#{node[:coldfusion][:application]}",
    :username => node[:coldfusion][:tasks][:username],
    :password => node[:coldfusion][:tasks][:password],
    :mailserver => node[:coldfusion][:mail][:server]
  )
end


ruby_block "permissions" do
  block do
    system "chmod -R 777 /home/webapps/#{node[:coldfusion][:application]}/temp/"
    system "mkdir /home/webapps/#{node[:coldfusion][:application]}/includes/localhost"
    system "mkdir /opt/jrun4/Mail/Fail"
    system "chmod 755 /opt/jrun4/Mail/Fail"
    system "chown nobody.nogroup /opt/jrun4/Mail/Fail"
  end
end

ruby_block "run admin api" do
  block do
    system "curl localhost:8000/CFIDE/cfadmin.cfm"
  end
end

rightscale_marker :end
