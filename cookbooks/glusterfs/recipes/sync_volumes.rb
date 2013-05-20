#Cookbook Name:: unison
#
#Copyright SchoolSpring.com

rightscale_marker :begin

Chef::Log.info "===> Syncronizing volumes"

CMD_LOG = "/tmp/gluster.out.#{$$}"

TAG_MOUNT     = node[:glusterfs][:tag][:mount]
TAG_MOUNTED   = node[:glusterfs][:tag][:mounted]

cmd = "unison -fastcheck true -auto -batch #{node[:glusterfs][:sync][:local]} #{node[:glusterfs][:sync][:remote]}"

log "running #{cmd}"
log `#{cmd}`

rightscale_marker :end
