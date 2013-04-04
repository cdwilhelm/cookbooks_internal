rightscale_marker :begin

bash "clear cache" do
 cwd "/home/webapps/#{node[:symfony][:application]}/symfony"
 code <<-EOF
   /home/webapps/#{node[:symfony][:application]}/symfony/symfony cache:clear
 EOF
end

directory "/home/webapps/#{node[:symfony][:application]}/symfony/cache" do
  mode "777"
  recursive true
end

directory "/home/webapps/#{node[:symfony][:application]}/symfony/log" do
  mode "777"
  recursive true
end

rightscale_marker :end
