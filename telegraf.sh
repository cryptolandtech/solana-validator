cat <<EOF | sudo tee /etc/apt/sources.list.d/influxdata.list
deb https://repos.influxdata.com/ubuntu bionic stable
EOF
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
apt-get update
apt-get -y install telegraf
systemctl restart telegraf
systemctl enable --now telegraf
systemctl status telegraf




/etc/telegraf/telegraf.conf
----------------------

# Global Agent Configuration
[agent]
  hostname = "near"
  flush_interval = "15s"
  interval = "15s"


# Input Plugins
[[inputs.cpu]]
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = false
[[inputs.disk]]
    ignore_fs = ["tmpfs", "devtmpfs", "devfs"]
[[inputs.io]]
[[inputs.mem]]
[[inputs.net]]
[[inputs.system]]
[[inputs.swap]]
[[inputs.netstat]]
[[inputs.processes]]
[[inputs.kernel]]

# Output Plugin InfluxDB
[[outputs.influxdb]]
  database = "telegraf"
  urls = [ "http://IP:8086" ]
  username = ""
  password = ""
  
#to use docker
#--label="docker.group=nuw-st" add this when doing docker run

#[[inputs.docker]]
#  endpoint = "unix:///var/run/docker.sock"
#  gather_services = false
#  container_name_include = []
#  container_name_exclude = []
#  timeout = "5s"
# docker_label_include = ["nuw-st"]
#  docker_label_exclude = []
#  perdevice = true
#  total = false

