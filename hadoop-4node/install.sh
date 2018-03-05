sudo  dd of=/etc/hosts<<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.31.101 namenode
192.168.31.102 resourcemanager
192.168.31.103 slave1
192.168.31.104 slave2
EOF

tar xvzf jdk-8u161-linux-x64.tar.gz
tar xvzf hadoop-2.9.0.tar.gz

sudo dd of=/etc/profile.d/jdk.sh<<EOF 
export JAVA_HOME=/home/vagrant/jdk1.8.0_161
export PATH=$PATH:/home/vagrant/jdk1.8.0_161/bin
EOF

source /etc/profile

cd hadoop-2.9.0
sed -i '1i\export JAVA_HOME=/home/vagrant/jdk1.8.0_161' etc/hadoop/hadoop-env.sh
sudo dd of=/etc/profile.d/hadoop.sh<<EOF 
export HADOOP_HOME=/home/vagrant/hadoop-2.9.0
HADOOP_PREFIX=/home/vagrant/hadoop-2.9.0
export HADOOP_PREFIX
export HADOOP_CONF_DIR=/home/vagrant/hadoop-2.9.0/etc/hadoop
export HADOOP_YARN_HOME=/home/vagrant/hadoop-2.9.0
export PATH=$PATH:$HADOOP_PREFIX/bin
EOF

cat <<EOF >etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
  <name>fs.defaultFS</name>
  <value>hdfs://namenode:9000</value>
 </property>
 <property>
  <name>io.file.buffer.size</name>
  <value>131072</value>
  </property>
</configuration>
EOF
cat <<EOF >1.txt
aa
EOF
mkdir -p /home/vagrant/namenodedir 
mkdir -p /home/vagrant/datanodedir 

cat <<EOF >etc/hadoop/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
        <name>dfs.namenode.name.dir</name>
        <value>/home/vagrant/namenodedir</value>
    </property>	
	 <property>
        <name>dfs.blocksize</name>
        <value>268435456</value>
    </property>
	 <property>
        <name>dfs.namenode.handler.count</name>
        <value>100</value>
    </property>
	 <property>
        <name>dfs.datanode.data.dir</name>
        <value>/home/vagrant/datanodedir</value>
    </property>
</configuration>
EOF

cat <<EOF >etc/hadoop/yarn-site.xml
<?xml version="1.0"?>
<configuration>
<property>
        <name>yarn.acl.enable</name>
        <value>false</value>
    </property>
	  <property>
        <name>yarn.admin.acl</name>
        <value>*</value>
    </property>
	  <property>
        <name>yarn.log-aggregation-enable</name>
        <value>false</value>
    </property>	
	  <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>ResourceManager</value>
    </property>
	<property>
    <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
</property>
</configuration>
EOF

echo -e 'slave1\nslave2'>etc/hadoop/slaves