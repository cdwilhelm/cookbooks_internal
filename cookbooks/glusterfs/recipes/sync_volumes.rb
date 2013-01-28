#Cookbook Name:: unison
#
#Copyright SchoolSpring.com

rightscale_marker :begin

Chef::Log.info "===> Syncronizing volumes"

CMD_LOG = "/tmp/gluster.out.#{$$}"

cmd = "unison -auto -silent"
node[:glusterfs][:volume_pool].each do |volume|
  cmd += " #{node[:glusterfs][:client][:mount_point]}/#{volume}"
end

system "#{cmd} &> #{CMD_LOG}"

rightscale_marker :end
