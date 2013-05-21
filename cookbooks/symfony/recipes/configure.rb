rightscale_marker :begin

bash "mailserver update" do
 installation_dir = "/home/webapps/#{node[:symfony][:application]}"

 code <<-EOF
   sed -i "s/int-manage.schoolspring.com/#{node[:coldfusion][:mail][:server]}/g" #{installation_dir}/symfony/apps/employer/config/factories.yml
   sed -i "s/int-manage.schoolspring.com/#{node[:coldfusion][:mail][:server]}/g" #{installation_dir}/symfony/apps/reference/config/factories.yml
   sed -i "s/int-manage.schoolspring.com/#{node[:coldfusion][:mail][:server]}/g" #{installation_dir}/symfony/lib/ssError500.class.php
   sed -i "s/int-manage.schoolspring.com/#{node[:coldfusion][:mail][:server]}/g" #{installation_dir}/cgi-bin/nces.pl
 EOF
end

rightscale_marker :end
