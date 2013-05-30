#
# Cookbook Name:: coldfusion
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# Add the collectd exec plugin to the set of collectd plugins if it isn't already there.
# See cookbooks/rightscale/definitions/rightscale_enable_collectd_plugin.rb for the "rightscale_enable_collectd_plugin" definition.
rightscale_enable_collectd_plugin 'exec'

# Rebuild the collectd configuration file if necessary.
# Calls the cookbooks/rightscale/recipes/setup_monitoring.rb recipe.
include_recipe "rightscale::setup_monitoring"

# Create the collectd library plugins directory if necessary.
directory ::File.join(node[:rightscale][:collectd_lib], "plugins") do
  action :create
  recursive true
end

# Install the coldfusion collectd script into the collectd library plugins directory.
cookbook_file(::File.join(node[:rightscale][:collectd_lib], "plugins", 'coldfusion.rb')) do
  source "cfmonitor.rb"
  mode "0755"
  backup false
  cookbook 'coldfusion'
end

# Add a collectd config file for the coldfusion script with the exec plugin and restart collectd if necessary.
template File.join(node[:rightscale][:collectd_plugin_dir], 'coldfusion.conf') do
  backup false
  source "coldfusion_collectd_exec.erb"
  notifies :restart, resources(:service => "collectd")
end

rightscale_marker :end
