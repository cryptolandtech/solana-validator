## https://florianjensen.com/2018/03/30/set-up-tinc-on-ubuntu/ 
#vm1 celop
apt-get update
apt-get install tinc
mkdir -p /etc/tinc/netname/hosts
vi /etc/tinc/netname/tinc.conf
  Name = celop
  AddressFamily = ipv4
  Interface = tun0
  
vi /etc/tinc/netname/hosts/celop
  Address = ams_public_IP
  Subnet = 10.0.0.1/32
  
tincd -n netname -K4096

vi /etc/tinc/netname/tinc-up
  ifconfig $INTERFACE 10.0.0.1 netmask 255.255.255.0
  
vi /etc/tinc/netname/tinc-down
  ifconfig $INTERFACE down

chmod +x /etc/tinc/netname/tinc-*

#vm2 celov
apt-get update
apt-get install tinc
mkdir -p /etc/tinc/netname/hosts
vi /etc/tinc/netname/tinc.conf
    Name = celov
    AddressFamily = ipv4
    Interface = tun0

vi /etc/tinc/netname/hosts/celov
  Address = ams_public_IP
  Subnet = 10.0.0.2/32
  
tincd -n netname -K4096

vi /etc/tinc/netname/tinc-up
  ifconfig $INTERFACE 10.0.0.2 netmask 255.255.255.0

vi /etc/tinc/netname/tinc-down
  ifconfig $INTERFACE down

chmod +x /etc/tinc/netname/tinc-*
