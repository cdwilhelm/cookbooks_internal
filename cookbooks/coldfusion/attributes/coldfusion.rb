tarball = "commons-pool-1.5.6-bin.tar.gz"

set_unless[:coldfusion][:tarball] = tarball
set_unless[:coldfusion][:jedis_url] = "https://github.com/downloads/xetorthio/jedis/jedis-2.1.0.jar"
set_unless[:coldfusion][:commons_url] = "http://archive.apache.org/dist/commons/pool/binaries/#{tarball}"
set_unless[:coldfusion][:jar_dir] = "/opt/jrun4/lib"
