#
# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

log "Setting up directory structure"

couchbase do
  action :stop
end

unless (node[:block_device].nil? or
        node[:block_device][:devices].nil? or
        node[:block_device][:devices][:device1].nil? or
        node[:block_device][:devices][:device1][:mount_point].nil?)
  mount_point = node[:block_device][:devices][:device1][:mount_point]

  log "configuring to mount_point: #{mount_point}"

  execute "moving directory" do
    command "mv /opt/couchbase #{mount_point}"
    action :run
  end

  execute "symlinking directory" do
    command "ln -s #{mount_point}/couchbase /opt/"
    action :run
  end
  
end

couchbase do
  action :start
end

rightscale_marker :begin

  initial_launch = node[:couchbase][:initial_launch]

log "Couchbase initial setup set to #{initial_launch}"

case initial_launch
  when "TRUE"
    log "Setting data path."
    bash "setup data path " do
      flags "-ex"
      code <<-EOH
      /opt/couchbase/bin/couchbase-cli node-init -c localhost -u none -p none --node-init-data-path=/mnt/ebs/Couchbase/opt/couchbase/var/lib/couchbase/data/
     EOH
    end
  else
    include_recipe "block_device::do_primary_restore"
end

rightscale_marker :end
