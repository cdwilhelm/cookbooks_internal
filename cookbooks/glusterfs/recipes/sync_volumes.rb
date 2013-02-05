#Cookbook Name:: unison
#
#Copyright SchoolSpring.com

rightscale_marker :begin

Chef::Log.info "===> Syncronizing volumes"

CMD_LOG = "/tmp/gluster.out.#{$$}"

TAG_MOUNT     = node[:glusterfs][:tag][:mount]
TAG_MOUNTED   = node[:glusterfs][:tag][:mounted]

r = server_collection "gluster_mounts" do
  tags "#{TAG_MOUNTED}=true"
  action :nothing
end
r.run_action(:load)


cmd = "unison -auto"

node[:server_collection]["gluster_mounts"].each do |id, tags|
  ip_tag = tags.detect { |i| i =~ /^server:public_ip_0=/ }
  ip = ip_tag.gsub(/^.*=/, '')
  mount_tag = tags.detect { |i| i =~ /#{TAG_MOUNT}=/ }
  mount = mount_tag.gsub(/^.*=/, '')
  if ip == node[:cloud][:public_ips][0]
    log "===> Added local mount #{mount}"
    cmd += " #{mount}"
  else
    log "===> Found server #{ip} mount #{mount}"
    cmd += " ssh://#{ip}/#{mount}"
  end
end

log "running #{cmd}"
log `#{cmd} &> #{CMD_LOG}`

rightscale_marker :end
