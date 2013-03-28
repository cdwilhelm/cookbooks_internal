rightscale_marker :begin

ruby_block "stop cf" do
  block do
    system "/opt/jrun4/bin/jrun stop cfusion"
  end
end

File.unlink '/mnt/ephemeral/cf.log' if File.exists?('/mnt/ephemeral/cf.log');

rightscale_marker :end
