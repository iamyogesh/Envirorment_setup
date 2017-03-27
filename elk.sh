install_elastic(){
#rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
#wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.noarch.rpm
#elasticsearch.repo >> /etc/yum.repos.d/elasticsearch.repo
#cp elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
yum -y install elasticsearch
systemctl start elasticsearch
systemctl enable elasticsearch
}

install_elasticsearch(){
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.1.2.tar.gz
#sha1sum elasticsearch-5.1.2.tar.gz 
tar -xzf elasticsearch-5.1.2.tar.gz
cd elasticsearch-5.1.2/
./bin/elasticsearch
}

install_kibana(){
cp kibana.repo /etc/yum.repos.d/kibana.repo
yum -y install kibana
#vi /opt/kibana/config/kibana.yml
# server.host: "localhost"
systemctl start kibana
chkconfig kibana on

service kibana start
#service kibana stop
# /var/log/kibana/
# another way of starting service
#systemctl start kibana.service
#systemctl stop kibana.service
}

install_logstash(){
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp logstash.repo /etc/yum.repos.d/logstash.repo
yum -y install logstash
/etc/init.d/logstash start
systemctl daemon-reload
systemctl start logstash
systemctl enable logstash
# to test logstash pipeline
# bin/logstash -e 'input { stdin { } } output { stdout {} }'
}

install_beat(){
#Filebeat client is a lightweight, resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.1.0-x86_64.rpm
rpm -vi filebeat-5.1.0-x86_64.rpm
# check config
#/etc/filebeat/filebeat.yml
/etc/init.d/filebeat start
}

# install the file beat in the dev-server to get logs to logastash in your machine
# grok {
#     match => [ "message", "%{SYSLOGLINE}" ]
#     overwrite => [ "message" ]
# }

# input {
#     beats {
#         port => "5043"
#     }
# }
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
# output {
#     stdout { codec => rubydebug }
# }

# call arguments verbatim:
$@

