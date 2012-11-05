# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
#

# Stop couchbase
action :stop do
  bash "stop" do
    flags "-ex" 
    code <<-EOF
      kill -15 `cat "/opt/couchbase/var/lib/couchbase/couchbase-server.pid"`
      pkill -15 -u 101
      EOF
  end
end


# Start couchbase
action :start do
  service couchbase-server
  action  :stop
end
