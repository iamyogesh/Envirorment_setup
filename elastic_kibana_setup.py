
# install update 
update()
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
echo 'export JAVA_HOME=/usr/lib/jvm
export JRE_HOME=/usr/lib/jvm/jre' >> /etc/profile
}

elasticsearch()
{
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.rpm
sha1sum elasticsearch-6.0.0.rpm 
sudo rpm --install elasticsearch-6.0.0.rpm
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
}

kibana()
{
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-x86_64.rpm
sha1sum kibana-6.0.0-x86_64.rpm 
sudo rpm --install kibana-6.0.0-x86_64.rpm
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
systemctl start kibana.service
}

# call arguments verbatim:
$@
