rightscale_marker :begin

package "opendkim"
package "opendkim-tools"

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables(
    :destinations => node[:postfix][:destinations],
    :networks => node[:postfix][:networks]
  )
end


directory node[:postfix][:deploy_dir] do
  owner "nobody"
  group "root"
  mode 00755
  action :create
end

template "#{node[:postfix][:deploy_dir]}/datasource.pl" do
  source "datasource.pl.erb"
  variables(
    :gc_username => node[:postfix][:gc_username],
    :gc_password => node[:postfix][:gc_password],
    :database_name => node[:postfix][:db_name],
    :database_hostname => node[:postfix][:db_host],
    :database_username => node[:postfix][:db_user],
    :database_password => node[:postfix][:db_pass]
  )
end

rightscale_marker :end
