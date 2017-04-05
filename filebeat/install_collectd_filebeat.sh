c()
{
yum install collectd
yum install epel-release
service collectd start
systemctl start collectd.service
systemctl status collectd.service
}

b(){
#Filebeat client is a lightweight, resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.0-x86_64.rpm
rpm -vi filebeat-5.2.0-x86_64.rpm
# check config
#/etc/filebeat/filebeat.yml
/etc/init.d/filebeat start
}
# call arguments verbatim:
$@
~

