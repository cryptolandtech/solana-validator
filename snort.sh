#install

sudo apt-get update && sudo apt-get dist-upgrade -y

sudo dpkg-reconfigure tzdata

mkdir ~/snort_src
cd ~/snort_src

sudo apt-get install -y build-essential autotools-dev libdumbnet-dev \
libluajit-5.1-dev libpcap-dev zlib1g-dev pkg-config libhwloc-dev \
cmake

sudo apt-get install -y liblzma-dev openssl libssl-dev cpputest \
libsqlite3-dev uuid-dev

sudo apt-get install -y asciidoc dblatex source-highlight w3m

sudo apt-get install -y libtool git autoconf

sudo apt-get install -y bison flex

sudo apt-get install -y libnetfilter-queue-dev libmnl-dev

 cd ~/snort_src
 wget https://github.com/rurban/safeclib/releases/download/v04062019/libsafec-04062019.0-ga99a05.tar.gz
 tar -xzvf libsafec-04062019.0-ga99a05.tar.gz
 cd libsafec-04062019.0-ga99a05/
 ./configure
 make
 sudo make install
 
 cd ~/snort_src/
 wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
 tar -xzvf pcre-8.43.tar.gz
 cd pcre-8.43
 ./configure
 make
 sudo make install
 
 cd ~/snort_src
 wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.7/gperftools-2.7.tar.gz
 tar xzvf gperftools-2.7.tar.gz
 cd gperftools-2.7
 ./configure
 make
 sudo make install
 
 cd ~/snort_src
 wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
 tar -xzvf ragel-6.10.tar.gz
 cd ragel-6.10
 ./configure
 make
 sudo make install
 
 cd ~/snort_src
 wget https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz
 tar -xvzf boost_1_71_0.tar.gz
 
 cd ~/snort_src
 wget https://github.com/intel/hyperscan/archive/v5.2.0.tar.gz
 tar -xvzf v5.2.0.tar.gz
 mkdir ~/snort_src/hyperscan-5.2.0-build
 cd hyperscan-5.2.0-build/
 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_71_0/ ../hyperscan-5.2.0
 make
 sudo make install
 
 cd ~/snort_src
 wget https://github.com/google/flatbuffers/archive/v1.11.0.tar.gz \
 -O flatbuffers-v1.11.0.tar.gz
 tar -xzvf flatbuffers-v1.11.0.tar.gz
 mkdir flatbuffers-build
 cd flatbuffers-build
 cmake ../flatbuffers-1.11.0
 make
 sudo make install
 
 cd ~/snort_src
 git clone https://github.com/snort3/libdaq.git
 cd libdaq
 ./bootstrap
 ./configure
 make
 sudo make install
 
 sudo ldconfig
 
 cd ~/snort_src
 git clone git://github.com/snortadmin/snort3.git
 cd snort3
 ./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
 cd build
 make
 sudo make install
 
 /usr/local/bin/snort -V

#configure

export LUA_PATH=/usr/local/include/snort/lua/\?.lua\;\;
export SNORT_LUA_PATH=/usr/local/etc/snort

sh -c "echo 'export LUA_PATH=/usr/local/include/snort/lua/\?.lua\;\;' >> ~/.bashrc"
sh -c "echo 'export SNORT_LUA_PATH=/usr/local/etc/snort' >> ~/.bashrc"

sudo visudo -f /etc/sudoers.d/snort-lua
# adaugati linia de mai jos in fisier si salvati

Defaults env_keep += "LUA_PATH SNORT_LUA_PATH"

snort -c /usr/local/etc/snort/snort.lua

############
We need to create a systemD service to change these settings. First determine the name(s) of the
interfaces you will have snort listen on using ifconfig.
Once you know the name of your network interfaces, check the status of large-receive-oload (LRO)
and generic-receive-oload (GRO) for those interfaces. In the example below, my interface name is
ens3 (you’ll commonly see eth0 or ens160 as interface names as well, depending on the system type).
We use ethtool to check the status:
############
 noah@snort3:~$ sudo ethtool -k ens3 | grep receive-offload
 generic-receive-offload: on
 large-receive-offload: off [fixed]
 
###########
from this output, you can see that GRO is enabled, and LRO is disabled (the ’fixed’ means it can not
be changed). We need to ensure that both are set to ’o’ (or ’o [fixed]’). We could use the ethtool
command to disable LRO and GRO, but the setting would not persist across reboots. The solution is to
create a systemD script to set this every boot.
create the systemD script:
######
 sudo nano  /lib/systemd/system/ethtool.service

Enter the following information, replacing ens3 with your interface name:
[Unit]
 Description=Ethtool Configration for Network Interface
 
 [Service]
 Requires=network.target
 Type=oneshot
 ExecStart=/sbin/ethtool -K ens3 gro off
 ExecStart=/sbin/ethtool -K ens3 lro off

 [Install]
 WantedBy=multi-user.target
 
Once the file is created, enable the service:
 sudo systemctl enable ethtool
 sudo service ethtool start
 
 sudo ethtool -k enp35s0 | grep receive-offload
generic-receive-offload: off
large-receive-offload: off [fixed]

cd ~/snort_src/
wget https://www.snort.org/downloads/openappid/12159 -O OpenAppId-12159
tar -xzvf OpenAppId-12159
sudo cp -R odp /usr/local/lib/

sudo nano /usr/local/etc/snort/snort.lua

At line 89 (yours line number may be slightly dierent) you will see the appid = entry. You will want to
add the app_detector_dir option here, pointing to the parent folder of the odf folder we extracted
above. It should look like this:
 appid =
{
    −− appid requires this to use appids in rules
    app_detector_dir = '/usr/local/lib',
}

note that you must have four spaces (not a tab) for the indented line. Now we want to test the configuration
file loads correctly:
snort -c /usr/local/etc/snort/snort.lua --warn-all

sudo mkdir /usr/local/etc/snort/rules
sudo touch /usr/local/etc/snort/rules/local.rules

sudo mkdir /var/log/snort

sduo nano /usr/local/etc/snort/snort.lua #line 89
    appid =
{
    app_detector_dir = '/usr/local/lib',
    log_stats = true,
}

sudo snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/snort/rules/local.rules -i enp35s0 -A alert_fast -s 65535 -k none -l /var/log/snort

sudo chmod a+r /var/log/snort/appid_stats.log

cd ~/snort_src/
wget https://www.snort.org/downloads/community/snort3-community-rules.tar.gz
tar -xvzf snort3-community-rules.tar.gz
cd snort3-community-rules

sudo mkdir /usr/local/etc/snort/rules
sudo mkdir /usr/local/etc/snort/builtin_rules

sudo mkdir /usr/local/etc/snort/so_rules
sudo mkdir /usr/local/etc/snort/lists

sudo cp snort3-community.rules /usr/local/etc/snort/rules/
sudo cp sid-msg.map /usr/local/etc/snort/rules/

snort -c /usr/local/etc/snort/snort.lua \
 -R /usr/local/etc/snort/rules/snort3-community.rules
 
 sudo sed -i '17,$s/^# //' /usr/local/etc/snort/rules/snort3-community.rules
 
 sudo nano /usr/local/etc/snort/snort.lua
 
 ################
 at line 169, set enable_builtin_rules to true. Lines that start with two hyphens are comments (disabled
commands are commonly commented out), and are not parsed by snort when loaded. Remove the
two hyphens before enable_builtin_rules to enable this option. Remember that all indented lines in
your snort.lua must be four spaces (not a tab) or the configuration will not load. The ips module in
snort.lua should look like this:
##########
ips =
{
    -- use this to enable decoder and inspector alerts
    enable_builtin_rules = true,
  
   -- use include for rules files; be sure to set your path
   -- note that rules files can include other rules files
   --include = 'snort3-community.rules',
}

snort -c /usr/local/etc/snort/snort.lua

sudo nano /usr/local/etc/snort/snort_defaults.lua

#############
beginning at line 25, make the following modifications:
#######

25 RULE_PATH = '/usr/local/etc/snort/rules'
26 BUILTIN_RULE_PATH = '/usr/local/etc/snort/builtin_rules'
27 PLUGIN_RULE_PATH = '/usr/local/etc/snort/so_rules'
28
29 -- If you are using reputation preprocessor set these
30 WHITE_LIST_PATH = '/usr/local/etc/snort/lists'
31 BLACK_LIST_PATH = '/usr/local/etc/snort/lists'

sudo touch /usr/local/etc/snort/rules/ips.include
sudo touch /usr/local/etc/snort/rules/local.rules

sudo nano /usr/local/etc/snort/rules/ips.include

add:
include rules/snort3-community.rules
include rules/local.rules

sudo nano /usr/local/etc/snort/snort.lua

we’ll make sure the ips.include file is loaded by snort, and we’ll verify that the built-in rules are
enabled. From line 169, make sure your file matches the below (remember that indents are 4 spaces):
169 ips =
170 {
171 -- use this to enable decoder and inspector alerts
172 enable_builtin_rules = true,
173
174 -- use include for rules files; be sure to set your path
175 -- note that rules files can include other rules files
176 --include = 'snort3_community.rules'
177 include = RULE_PATH .. '/ips.include',
178 }

cd
mkdir pcaps
cd pcaps

wget https://download.netresec.com/pcap/maccdc-2012/maccdc2012_00000.pcap.gz
gunzip maccdc2012_00000.pcap.gz

wget https://download.netresec.com/pcap/maccdc-2012/maccdc2012_00001.pcap.gz
gunzip maccdc2012_00001.pcap.gz

snort -c /usr/local/etc/snort/snort.lua \
 -r ~/pcaps/maccdc2012_00000.pcap -A alert_fast -s 65535 -k none
 
 sudo nano /usr/local/etc/snort/snort.lua
 
--alert_csv =
--{
--file = true,
--}
alert_json =
{
    file = true,
    limit = 10,
    fields = 'seconds action class b64_data dir dst_addr \
    dst_ap dst_port eth_dst eth_len eth_src eth_type gid icmp_code \
    icmp_id icmp_seq icmp_type iface ip_id ip_len msg mpls pkt_gen \
    pkt_len pkt_num priority proto rev rule service sid src_addr \
    src_ap src_port target tcp_ack tcp_flags tcp_len tcp_seq \
    tcp_win tos ttl udp_len vlan timestamp',
}

sudo snort -c /usr/local/etc/snort/snort.lua --pcap-filter \*.pcap \
 --pcap-dir ~/pcaps -l /var/log/snort -s 65535 -k none -m 0x1b
 
 ls -lh /var/log/snort
 
 sudo groupadd snort
 sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
 
 sudo rm /var/log/snort/*
 
 sudo chmod -R 5775 /var/log/snort
 sudo chown -R snort:snort /var/log/snort
 
 sudo nano /lib/systemd/system/snort3.service
 
 [Unit]
Description=Snort3 NIDS Daemon
After=syslog.target network.target

 [Service]
Type=simple
ExecStart=/usr/local/bin/snort -c /usr/local/etc/snort/snort.lua -s 65535 \
 -k none -l /var/log/snort -D -u snort -g snort -i eth0 -m 0x1b

 [Install]
WantedBy=multi-user.target

sudo systemctl enable snort3
sudo service snort3 start

service snort3 status

sudo journalctl -u snort3.service
