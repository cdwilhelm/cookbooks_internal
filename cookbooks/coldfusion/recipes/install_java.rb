
rightscale_marker
log "installing Java 1.7"

case  node[:platform]
when "centos|redhat"
 packages=["java-1.7.0-openjdk"]
when "ubuntu"
 packages=["openjdk-7-jre"]
end

packages.each do |p|
 package p
end

