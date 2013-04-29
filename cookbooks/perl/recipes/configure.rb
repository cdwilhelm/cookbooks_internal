rightscale_marker :begin

template "/home/webapps/#{node[:coldfusion][:application]}/cgi-bin/datasource.pl" do
  source "datasource.pl.erb"
  mode 00644
  variables(
    :hostname => node[:coldfusion][:db][:hostname],
    :db_user => node[:coldfusion][:db][:username],
    :db_pass => node[:coldfusion][:db][:password],
    :master_schema => node[:coldfusion][:db][:master_schema],
    :webroot => "/home/webapps/#{node[:coldfusion][:application]}"
  )
end

rightscale_marker :end
