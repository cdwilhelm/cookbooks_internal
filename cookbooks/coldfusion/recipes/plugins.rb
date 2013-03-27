rightscale_marker :begin

remote_file "#{node[:coldfusion][:jar_dir]}/jedis-2.1.0.jar" do
 source node[:coldfusion][:jedis_url]
 mode "0644"
end

remote_file "/tmp/#{node[:coldfusion][:tarball]}" do
 source node[:coldfusion][:commons_url]
 mode "0644"
end

execute "tar" do
 installation_dir = "/tmp/"
 cwd installation_dir
 command "tar zxf /tmp/#{node[:coldfusion][:tarball]}"
 creates installation_dir + "/commons-pool-1.5.6"
 action :run
end

file "#{node[:coldfusion][:jar_dir]}/commons-pool-1.5.6.jar" do
  content IO.read("/tmp/commons-pool-1.5.6/commons-pool-1.5.6.jar")
end

rightscale_marker :end
