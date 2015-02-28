rightscale_marker :begin

directory "/home/webapps/#{node[:symfony][:application]}/symfony/cache" do
  mode "777"
  recursive true
end

directory "/home/webapps/#{node[:symfony][:application]}/symfony/log" do
  mode "777"
  recursive true
end

rightscale_marker :end
