rightscale_marker :begin

require 'rubygems' 
require 'right_aws' 

include_recipe "coldfusion::install_java"

ruby_block "pull down coldfusion bin from s3" do
  s3= RightAws::S3Interface.new(node[:coldfusion][:amazon][:aws_key], node[:coldfusion][:amazon][:aws_secret])
  localfile = File.new("/tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin" , File::CREAT|File::RDWR)
  rhdr = s3.get(node[:coldfusion][:s3][:dl_bucket], "#{node[:coldfusion][:s3][:dl_file]}2012-12-13.bin") do |chunk|
    localfile.write(chunk)
  end
  localfile.close
  not_if { File.exists?("/tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin") }
end

template "/tmp/cf902silent.properties" do
  mode 00644
  source "cf902silent.properties.erb"
  variables(
    :serial_number => node[:coldfusion][:serial_number],
    :previous_serial => node[:coldfusion][:previous_serial],
    :webroot => "/home/webapps/#{node[:coldfusion][:application]}/www",
    :admin_password => node[:coldfusion][:admin_password]
  )
  not_if do
    File.exists?('/tmp/cf902silent.properties')
  end
end

bash "run cf installer" do
  cwd "/tmp"
  code <<-EOH
    chmod 777 /tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin
    /tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin -f /tmp/cf902silent.properties >& out
  EOH
  not_if do
    File.exists?('/opt/jrun4')
  end
end

ruby_block "pull down coldfusion bin from s3" do
  s3= RightAws::S3Interface.new(node[:coldfusion][:amazon][:aws_key], node[:coldfusion][:amazon][:aws_secret])
  localfile = File.new("/tmp/CF902.zip" , File::CREAT|File::RDWR)
  rhdr = s3.get(node[:coldfusion][:s3][:dl_bucket], node[:coldfusion][:s3][:hotfix_file]) do |chunk|
    localfile.write(chunk)
  end
  localfile.close
  not_if { File.exists?("/tmp/CF902.zip") }
end

bash "run cf installer" do
  cwd "/tmp"
  code <<-EOH
    unzip -j CF902.zip CF902/lib/updates/hf* -d /opt/jrun4/lib/updates/.
  EOH
end

ruby_block "pull down coldfusion bin from s3" do
  s3= RightAws::S3Interface.new(node[:coldfusion][:amazon][:aws_key], node[:coldfusion][:amazon][:aws_secret])
  localfile = File.new("/tmp/CFIDE-902.zip" , File::CREAT|File::RDWR)
  rhdr = s3.get(node[:coldfusion][:s3][:dl_bucket], node[:coldfusion][:s3][:ide_hotfix_file]) do |chunk|
    localfile.write(chunk)
  end
  localfile.close
  not_if { File.exists?("/tmp/CF902.zip") }
end

bash "run cf installer" do
  cwd "/tmp"
  code <<-EOH
    unzip CFIDE-902.zip -d /home/webapps/ssv2/www
    touch /tmp/ide-update-9.0.2-07
  EOH
  not_if do
    File.exists?('/tmp/ide-update-9.0.2-07')
  end
end

bash "permissions" do
  code <<-EOF
   sed -i "s/<var name='postParametersLimit'><number>100.0/<var name='postParametersLimit'><number>500.0/g" /opt/jrun4/lib/neo-runtime.xml
  EOF
end

rightscale_marker :end
