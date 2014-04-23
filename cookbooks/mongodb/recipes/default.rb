rightscale_marker :begin

case node[:platform]
when 'centos'
    package "mongodb"
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end
