#!/bin/bash

function banner()
{
echo -e "\n"
echo -e "\u001b[32m██╗  ██╗ █████╗ ██████╗  ██████╗  ██████╗ ██████╗                                          ";
echo -e "\u001b[32m██║  ██║██╔══██╗██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗                                         ";
echo -e "\u001b[32m███████║███████║██║  ██║██║   ██║██║   ██║██████╔╝                                         ";
echo -e "\u001b[32m██╔══██║██╔══██║██║  ██║██║   ██║██║   ██║██╔═══╝                                          ";
echo -e "\u001b[32m██║  ██║██║  ██║██████╔╝╚██████╔╝╚██████╔╝██║                                              ";
echo -e "\u001b[32m╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚═════╝ ╚═╝                                              ";
echo -e "\u001b[32m██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                                          ";
echo -e "\u001b[32m██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                                          ";
echo -e "\u001b[32m██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                                          ";
echo -e "\u001b[32m██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                                          ";
echo -e "\u001b[32m██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗                                     ";
echo -e "\u001b[32m╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝                                     ";
echo -e "\u001b[32m██████╗ ██╗   ██╗    ██████╗ ██╗██████╗  █████╗ ███╗   ██╗███████╗██╗  ██╗██╗   ██╗ ██╗██╗ ";
echo -e "\u001b[32m██╔══██╗╚██╗ ██╔╝    ██╔══██╗██║██╔══██╗██╔══██╗████╗  ██║██╔════╝██║  ██║██║   ██║██╔╝╚██╗";
echo -e "\u001b[32m██████╔╝ ╚████╔╝     ██║  ██║██║██████╔╝███████║██╔██╗ ██║███████╗███████║██║   ██║██║  ██║";
echo -e "\u001b[32m██╔══██╗  ╚██╔╝      ██║  ██║██║██╔═══╝ ██╔══██║██║╚██╗██║╚════██║██╔══██║██║   ██║██║  ██║";
echo -e "\u001b[32m██████╔╝   ██║       ██████╔╝██║██║     ██║  ██║██║ ╚████║███████║██║  ██║╚██████╔╝╚██╗██╔╝";
echo -e "\u001b[32m╚═════╝    ╚═╝       ╚═════╝ ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═╝╚═╝ ";
echo -e "\u001b[32m                                                                                           ";



}
banner

# # Only display if the UID does NOT match 1000.
# function check_user(){
# 	UID_TO_TEST='0'
# 	if [[ "${UID}" != "${UID_TO_TEST}" ]]
# 	then
		
# 		echo "Your are ${USERNAMEecho -e "\u001b[31m------------------------------------"
# 	fi
# }




function updating(){
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mUpdating the system first...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"
	sudo apt update
	sudo apt-get install ssh openjdk-8-jdk -y

}

updating

function installing_hadoop(){
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mDownloading hadoop...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "hello"	echo -e "hello"

	if [[ ! -f 'hadoop-2.6.3.tar.gz' ]] 
	then
		wget https://archive.apache.org/dist/hadoop/common/hadoop-2.6.3/hadoop-2.6.3.tar.gz
	fi

	tar -xzvf hadoop-2.6.3.tar.gz
	sudo mv hadoop-2.6.3 /usr/local/hadoop
	sudo chown -R $USERNAME:$USERNAME /usr/local/hadoop

}

installing_hadoop

function setup_hadoop(){
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mChanging the default java version...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"

	sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

	echo -e "\u001b[31m------------------------------------\e[0m"
 	echo -e "\u001b[31mInitalizing the ssh"
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"

	echo -e "\n\n\n" | ssh-keygen -t rsa
	cat /home/$USERNAME/.ssh/id_rsa.pub > /home/$USERNAME/.ssh/authorized_keys 
	sudo systemctl start sshd

	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mAdding Hadoop Variables...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"

	sed -i 's|${JAVA_HOME}|/usr/lib/jvm/java-1.8.0-openjdk-amd64|g' /usr/local/hadoop/etc/hadoop/hadoop-env.sh


	#HADOOP VARIABLES START
	export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
	export HADOOP_INSTALL=/usr/local/hadoop
	export PATH=$PATH:$HADOOP_INSTALL/bin
	export PATH=$PATH:$HADOOP_INSTALL/sbin
	export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
	export HADOOP_COMMON_HOME=$HADOOP_INSTALL
	export HADOOP_HDFS_HOME=$HADOOP_INSTALL
	export YARN_HOME=$HADOOP_INSTALL
	export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
	export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
	#HADOOP VARIABLES END


	
	echo -e '#HADOOP VARIABLES START' >> /home/$USERNAME/.bashrc
	echo -e	'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' >> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_INSTALL=/usr/local/hadoop' >> /home/$USERNAME/.bashrc
	echo -e	'export PATH=$PATH:$HADOOP_INSTALL/bin' >> /home/$USERNAME/.bashrc
	echo -e	'export PATH=$PATH:$HADOOP_INSTALL/sbin' >> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_MAPRED_HOME=$HADOOP_INSTALL'>> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_COMMON_HOME=$HADOOP_INSTALL' >> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_HDFS_HOME=$HADOOP_INSTALL' >> /home/$USERNAME/.bashrc
	echo -e	'export YARN_HOME=$HADOOP_INSTALL' >> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native' >> /home/$USERNAME/.bashrc
	echo -e	'export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"' >> /home/$USERNAME/.bashrc
	echo -e	'#HADOOP VARIABLES END' >> /home/$USERNAME/.bashrc
	source ~/.bashrc
	# hadoop

	# echo "Reboot Requried!!!"


}
setup_hadoop

function config_hadoop(){

	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mConfiguring the Hadoop...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"

	sudo mkdir -p /app/hadoop/tmp
	sudo chown  $USERNAME:$USERNAME  /app/hadoop/tmp
	cat << 'EOF' > /usr/local/hadoop/etc/hadoop/core-site.xml
		<configuration>
		<property>
			<name>hadoop.tmp.dir</name>
			<value>/app/hadoop/tmp</value>
			<description>A base for other temporary directories.</description>
		</property>
		<property>
			<name>fs.default.name</name>
			<value>hdfs://localhost:54310</value>
			<description>The name of the default file system. A URI whose scheme and authority the FileSystem implementation. The uri's scheme determines the config property (fs.SCHEME.impl) naming the FileSystem implementation class. The uri's authority is used to determine the host, port, etc. for a filesystem.
			</description>
		</property>
		</configuration>
EOF


	# if [[ ! -f "/usr/local/hadoop/etc/hadoop/mapred-site.xml" ]]; then
	# 	cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml
	# fi

	[ ! -f "/usr/local/hadoop/etc/hadoop/mapred-site.xml" ] && 	 cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml || cat << 'EOF' > /usr/local/hadoop/etc/hadoop/mapred-site.xml
	<configuration>
	<property>
	<name>mapred.job.tracker</name>
	<value>localhost:54311</value>
	<description>
		The host and port that the MapReduce job tracker runs at. If "local", then jobs are run-process as a single map and reduce task.
	</description>
	</property>
	</configuration>
EOF

	sudo mkdir -p /usr/local/hadoop_store/hdfs/namenode
	sudo mkdir -p /usr/local/hadoop_store/hdfs/datanode
	sudo chown -R $USERNAME:$USERNAME /usr/local/hadoop_store

	cat << 'EOF' > /usr/local/hadoop/etc/hadoop/hdfs-site.xml
		<configuration>
		<property>
		<name>dfs.replication</name>
		<value>1</value>
		<description>Default block replication.
		The actual number of replications can be specified when the file is created.
		The default is used if replication is not specified in create time.
		</description>
		</property>
		<property>
		<name>dfs.namenode.name.dir</name>
		<value>file:/usr/local/hadoop_store/hdfs/namenode</value>
		</property>
		<property>
		<name>dfs.datanode.data.dir</name>
		<value>file:/usr/local/hadoop_store/hdfs/datanode</value>
		</property>
		</configuration>
EOF

}

config_hadoop

function start_hadoop(){
	
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\u001b[1;31mStarting The Hadoop...."
	echo -e "\u001b[31m------------------------------------\e[0m"
	echo -e "\n"

	hadoop namenode -format
	/usr/local/hadoop/sbin/start-all.sh
	jps
	echo -e "Accessing HADOOP through browser \nhttp://localhost:50070/ \nVerify all applications for cluster \nhttp://localhost:8088/"

}

start_hadoop
