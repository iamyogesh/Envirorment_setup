
# install update 
download_update()
{
yum -y update
yum -y install wget
}

install_java()
{
#install java
echo "downloading java-1.8.0-openjdk"
yum -y install java-1.8.0-openjdk
echo "writing  path to a file /etc/profile"
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export JRE_HOME=/usr/lib/jvm/jre' >> /etc/profile
}


install_mongo()
{
#install mongo
echo '[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc' >> /etc/yum.repos.d/mongodb-org.repo

echo "file has been written to /etc/yum.repos.d/mongodb-org.repo"

echo "installing mongo from yum"
yum -y install mongodb-org
echo "starting mongod service"
systemctl start mongod
echo "to check service is started logs--> tail /var/log/mongodb/mongod.log"
echo "Done starting mongo"
}

install_mysql()
{
#install mysql
echo "downloading mysql repository"
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum -y update
yum -y install mysql-server
echo "mysqlserver is installed"
echo "starting mysql server"
systemctl start mysqld
mysql_secure_installation
echo "mysqlserver is configured"
# give root password
#'SmartCity@123' 
}


install_kafka()
{
# install kafka
echo "Starting downloading kafka file"
wget http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
tar -xvf kafka_2.11-0.9.0.1.tgz
mv kafka_2.11-0.9.0.1 /opt
echo "Done file is moved to /opt"

echo "Adding kafka user"
useradd kafka
chown -R kafka /opt/kafka_2.11-0.9.0.1
ln -s /opt/kafka_2.11-0.9.0.1 /opt/kafka
chown -h kafka /opt/kafka
echo "Done Adding kafka user"
echo "Adding kafka_service file to /etc/systemd/system/kafka.service"
cp kafka_service /etc/systemd/system/kafka.service
echo "Done file has been written to /etc/systemd/system/kafka.service "

echo "Adding kafka_zookeeper file to /etc/systemd/system/kafka-zookeeper.service"
cp kafka_zookeeper /etc/systemd/system/kafka-zookeeper.service
echo "Done file has been written to /etc/systemd/system/kafka-zookeeper.service"

echo "Done kafka is started"
echo "enabling kafka and zookeper"
systemctl enable kafka-zookeeper.service
systemctl enable kafka.service

echo "starting kafka-zookeeper"
systemctl daemon-reload
systemctl start kafka-zookeeper.service
systemctl status kafka-zookeeper.service
# to check logs ---> /var/log/messages
echo "to check logs ----> /var/log/messages"
echo "Done kafka-zookeeper is started"
echo "starting kafka"
systemctl start kafka.service
systemctl status kafka.service
# to check logs ---> /var/log/messages
echo "to check logs ----> /var/log/messages"
}

install_rabbitmq()
{
# install rabbitmq
echo "installing Erlang"
yum -y install epel-release
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
yum install -y erlang-19.0
yum -y install socat
echo "Done installing Erlang"
echo "Installing rabbitmq"
rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.3/rabbitmq-server-3.6.3-1.noarch.rpm
chkconfig rabbitmq-server on
echo "ulimit -S -n 4096" >> /etc/rabbitmq/raabitmq-env.conf

echo "Done Installing rabbitmq"
echo "starting rabbitmq server"
/etc/init.d/rabbitmq-server start
rabbitmq-plugins enable rabbitmq_mqtt
echo "to check rabbitmq is started --> /etc/init.d/rabbitmq-server status"
echo "Done starting rabbitmq server"
sed -i 's/enforcing/permissive/g' /etc/selinux/config
#reboot
}

firewall_open_port()
{
#enble ports
firewall-cmd --permanent --add-port=1883/tcp
firewall-cmd --permanent --add-port=2021/tcp
firewall-cmd --permanent --add-port=2022/tcp
firewall-cmd --permanent --add-port=2181/tcp
firewall-cmd --permanent --add-port=5672/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=15675/tcp
firewall-cmd --permanent --add-port=9092/tcp
firewall-cmd --permanent --add-port=10001/tcp
firewall-cmd --permanent --add-port=10002/tcp
firewall-cmd --permanent --add-port=11001/tcp
firewall-cmd --permanent --add-port=11002/tcp
firewall-cmd --permanent --add-port=12001/tcp
firewall-cmd --permanent --add-port=12002/tcp
firewall-cmd --permanent --add-port=50101/tcp
firewall-cmd --permanent --add-port=50102/tcp
firewall-cmd --permanent --add-port=50201/tcp
firewall-cmd --permanent --add-port=50202/tcp
firewall-cmd --permanent --add-port=50301/tcp
firewall-cmd --permanent --add-port=50302/tcp
firewall-cmd --reload
}

install_tomcat()
{
        echo "tomcat instalation started"
       # cd /opt/
       # groupadd tomcat
       # useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
        echo "downloading tomacat .tar files"
        wget http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.0.M15/bin/apache-tomcat-9.0.0.M15.tar.gz
        tar -xzvf apache-tomcat-9.0.0.M15.tar.gz
        mv apache-tomcat-9.0.0.M15/* tomcat/
        echo "tomcat file is installed and moved"
}

test_tomcat()
{
        cd /opt/tomcat/bin/
        ./startup.sh
}
tomcat_service()
{
        cp tomcat_service /etc/systemd/system/tomcat.service
        systemctl daemon-reload
        systemctl start tomcat
        systemctl enable tomcat
}
# call arguments verbatim:
$@
