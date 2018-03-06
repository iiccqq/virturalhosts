sudo  dd of=/etc/hosts<<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.31.101 namenode
192.168.31.111 master zoo1
192.168.31.112 hbaseregion1 zoo2 backup
192.168.31.113 hbaseregion2 zoo3
EOF

tar xvzf jdk-8u161-linux-x64.tar.gz
tar xvzf hadoop-2.9.0.tar.gz
tar xvzf zookeeper-3.4.10.tar.gz
tar xvzf hbase-1.2.6-bin.tar.gz
sudo dd of=/etc/profile.d/jdk.sh<<EOF 
export JAVA_HOME=/home/vagrant/jdk1.8.0_161
export PATH=$PATH:/home/vagrant/jdk1.8.0_161/bin
EOF

mkdir -p /home/vagrant/zookeeper/data
mkdir -p /home/vagrant/zookeeper/log

source /etc/profile
cd zookeeper-3.4.10
cat <<EOF >conf/zoo.cfg
tickTime=2000
dataDir=/home/vagrant/zookeeper/data
dataLogDir=/home/vagrant/zookeeper/log
clientPort=2181
initLimit=5
syncLimit=2
server.1=zoo1:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
EOF

cd ../hbase-1.2.6
cat <<EOF >conf/hbase-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
  <name>hbase.cluster.distributed</name>
  <value>true</value>
</property>
<property>
  <name>hbase.rootdir</name>
  <value>hdfs://namenode:9000/hbase</value>
</property>
 <property>
    <name>hbase.zookeeper.quorum</name>
    <value>zoo1,zoo2,zoo3</value>
  </property>
  <property> 
　　　　<name>hbase.zookeeper.property.dataDir</name> 
　　　　<value>/home/vagrant/zookeeper/hbasedata</value> 
　　</property>
</configuration>
EOF


echo -e 'hbaseregion1\nhbaseregion2'>conf/regionservers
echo -e 'backup'>conf/backup-masters
