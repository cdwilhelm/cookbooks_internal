rightscale_marker :begin

remote_file "#{node[:coldfusion][:jar_dir]}/jedis-2.1.0.jar" do
 source node[:coldfusion][:jedis_url]
 owner 'root'
 group 'root'
 mode 00644
end

remote_file "#{Chef::Config['file_cache_path']}/#{node[:coldfusion][:tarball]}" do
 owner 'root'
 group 'root'
 source node[:coldfusion][:commons_url]
 mode 00644
end

system "tar zxf #{Chef::Config['file_cache_path']}/#{node[:coldfusion][:tarball]}"

file "#{node[:coldfusion][:jar_dir]}/commons-pool-1.6.jar" do
  content IO.read("#{Chef::Config['file_cache_path']}/commons-pool-1.6/commons-pool-1.6.jar")
end

rightscale_marker :end
