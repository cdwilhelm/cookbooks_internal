rightscale_marker :begin

remote_file "#{node[:coldfusion][:jar_dir]}/jedis-2.1.0.jar" do
 source node[:coldfusion][:jedis_url]
 owner 'root'
 group 'root'
 mode 00644
end

bash 'extract_module' do
  cwd "/tmp"
  code <<-EOH
    wget #{node[:coldfusion][:commons_url]}
    tar xzf #{src_filename}
    EOH
end

file "#{node[:coldfusion][:jar_dir]}/commons-pool-1.6.jar" do
  content IO.read("#{Chef::Config['file_cache_path']}/commons-pool-1.6/commons-pool-1.6.jar")
end

rightscale_marker :end
