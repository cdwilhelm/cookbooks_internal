rightscale_marker :begin

file "#{node[:coldfusion][:jar_dir]}/neo-cron.xml" do
  action :delete
end

cookbook_file "#{node[:coldfusion][:jar_dir]}/neo-cron.xml" do
  source "neo-cron.xml"
  mode 0755
  owner "root"
  group "root"
end

rightscale_marker :end
