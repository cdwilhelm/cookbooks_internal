rightscale_marker :begin

remote_file "#{node[:coldfusion][:jar_dir]}/jedis-2.1.0.jar" do
 source node[:coldfusion][:jedis_url]
 owner 'root'
 group 'root'
 mode 00644
end

bash 'extract_module' do
  cwd "/mnt/ephemeral"
  code <<-EOH
    wget #{node[:coldfusion][:commons_url]}
    tar xzf #{node[:coldfusion][:tarball]}
    cp commons-pool-1.6/commons-pool-1.6.jar #{node[:coldfusion][:jar_dir]}
    EOH
end

rightscale_marker :end
