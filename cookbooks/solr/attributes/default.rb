default[:solr][:install_dir] = '/usr/share/tomcat6/solr'
default[:solr][:conf_dir] = node[:solr][:install_dir] + '/conf'
default[:solr][:lib_dir] = node[:solr][:install_dir] + '/lib'
default[:solr][:data_dir] = node[:solr][:install_dir] + '/data'