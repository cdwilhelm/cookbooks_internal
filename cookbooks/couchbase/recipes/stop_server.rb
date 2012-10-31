# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


rightscale_marker :begin

log("service couchbase-server stop")

# You should just be able to put 
# service couchbase stop
#
service "couchbase-server" do
  action :stop
end
# Or brute force
#execute "stopping server" do
#   command "kill -15 `cat "/opt/couchbase/var/lib/couchbase/couchbase-server.pid"`
#pkill -15 -u 101"
#   action :run
# end

rightscale_marker :end


