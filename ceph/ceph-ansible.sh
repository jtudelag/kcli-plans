yum install -y  wget vim screen git python telnet ceph-ansible
cp -pR /usr/share/ceph-ansible /root/ceph-ansible
cp  /root/ceph-ansible/group_vars/all.yml.sample  /root/ceph-ansible/group_vars/all.yml
cp /root/ceph-ansible/group_vars/osds.yml.sample /root/ceph-ansible/group_vars/osds.yml
cp /root/ceph-ansible/group_vars/mons.yml.sample /root/ceph-ansible/group_vars/mons.yml
cp /root/ceph-ansible/group_vars/rgws.yml.sample /root/ceph-ansible/group_vars/rgws.yml
cp /root/ceph-ansible/site.yml.sample /root/ceph-ansible/site.yml
mkdir ~/ceph-ansible-keys
#cd /root && git clone https://github.com/likid0/pre-ceph-ansible.git
echo "host_key_checking = False" >> /root/ceph-ansible/ansible.cfg
cat << EOF >> /root/ceph-ansible/group_vars/all.yml
fetch_directory: ~/ceph-ansible-keys
ntp_service_enabled: true
ceph_rhcs: true
ceph_rhcs_cdn_install: true
ceph_stable_redhat_distro: el7
max_open_files: 151072
monitor_interface: eth0
journal_size: 5120 
public_network: 192.168.101.0/24
cluster_network: 10.0.0.0/24
osd_mkfs_type: xfs
osd_mkfs_options_xfs: -f -i size=2048
osd_mount_options_xfs: noatime,largeio,inode64,swalloc
ceph_conf_overrides:
  global:
    osd_pool_default_min_size: 1
EOF
cat << EOF >> /root/ceph-ansible/group_vars/osds.yml
fetch_directory: ~/ceph-ansible-keys
devices:
  - /dev/vdb
  - /dev/vdc
  - /dev/vdd
journal_collocation: true
EOF
cat << EOF >> /root/ceph-ansible/inventory
[mons]
192.168.101.20
192.168.101.30
192.168.101.40
[osds]
192.168.101.20
192.168.101.30
192.168.101.40
[clients]
192.168.101.10
[all:vars]
ansible_user=cloud-user
EOF
sleep 40
cd /root/ceph-ansible
ansible-playbook -i /root/ceph-ansible/inventory site.yml
