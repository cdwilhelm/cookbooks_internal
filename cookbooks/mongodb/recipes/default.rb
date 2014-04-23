rightscale_marker :begin

case node[:platform]
when 'centos'
    package "mongodb"
    package "mongodb-server"
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end
