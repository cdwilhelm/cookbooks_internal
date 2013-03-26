rightscale_marker :begin

tarball = "commons-pool-1.5.6-bin.tar.gz"

remote_file "/opt/jrun4/lib/jedis-2.1.0.jar" do
 source "https://github.com/downloads/xetorthio/jedis/jedis-2.1.0.jar"
 mode "0644"
end

remote_file "/tmp/#{tarball}" do
 source "http://archive.apache.org/dist/commons/pool/binaries/#{tarball}"
 mode "0644"
end

execute "tar" do
 installation_dir = "/tmp/"
 cwd installation_dir
 command "tar zxf /tmp/#{tarball}"
 creates installation_dir + "/commons-pool-1.5.6"
 action :run
end

file "/opt/jrun4/lib/commons-pool-1.5.6.jar" do
  content IO.read("/tmp/commons-pool-1.5.6/commons-pool-1.5.6.jar")
end

rightscale_marker :end
