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
    :mailserver => node[:coldfusion][:mail][:server]
  )
end

case node[:platform]
when "ubuntu","debian"
  ruby_block "wsconfig" do
    block do
      system "echo 'Include httpd.conf' >> /etc/apache2/apache2.conf"
      system "/opt/jrun4/runtime/bin/wsconfig -server coldfusion -ws Apache -dir /etc/apache2 -bin /usr/sbin/apache2 -script /usr/sbin/apache2ctl -coldfusion -v"
    end
  end
when "centos"
  package "httpd-devel"
  ruby_block "wsconfig" do
    block do
      system "/opt/jrun4/runtime/bin/wsconfig -server coldfusion -ws Apache -dir /etc/httpd/conf -bin /usr/sbin/httpd -script /usr/sbin/apachectl -coldfusion -v"
    end
  end
end

ruby_block "run admin api" do
  block do
    system "curl localhost:8000/CFIDE/cfadmin.cfm"
  end
end

ruby_block "permissions" do
  block do
    system "chmod -R 777 /home/webapps/#{node[:coldfusion][:application]}/temp/"
    system "mkdir /opt/jrun4/Mail/Fail"
    system "chmod 755 /opt/jrun4/Mail/Fail"
    system "chown nobody.nogroup /opt/jrun4/Mail/Fail"
  end
end

rightscale_marker :end

