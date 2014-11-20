
rightscale_marker
log "installing Java 1.7"

case  node[:platform]
when "centos|redhat"
 packages=["java-1.7.0-openjdk"]
when "ubuntu"
 packages=["openjdk-7-jdk", "icedtea-7-plugin"]
end

packages.each do |p|
 package p
end

case node[:platform]
when "centos|redhat"
# execute "update-java-alternatives" do
#   command "update-java-alternatives -s java-1.7.0-openjdk-amd64"
#   action :run
# end
when "ubuntu"
 execute "update-java-alternatives" do
   command "update-java-alternatives -s java-1.7.0-openjdk-amd64"
   action :run
 end
end
