Filebeat

Filebeat:
Filebeat modules simplify the collection, parsing, and visualization of common log formats.
Filebeat provides a set of pre-built modules that you can use to rapidly implement and deploy a log monitoring solution

step 1)filebeat need to be installed in source machine where log files are genarated using the script

$sh install_collectd_filebeat.sh b

step 2)we need to open a filewall port to communicate to elk machine.

firewall-cmd --permanent --add-port=5045/tcp

step 3) in elk machine logstash is installed its getting a data from filebeat using port 5045
run the .conf file from logstah directory
$bin/logstash -f filebeat_its_tomcat_apache.conf --config.test_and_exit
$bin/logstash -f filebeat_its_tomcat_apache.conf

which will send the data to elasticsearch




