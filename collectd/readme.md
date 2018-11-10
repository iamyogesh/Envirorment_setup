Pre-requisites

I am using one VM running Centos 7 for this post.

First, we have our Linux daemon gathering metrics.

Collectd – Used to collect metrics from our system(s). We could be using Collectd in multiple systems to collect each system’s metrics.
Then we have the rest of the tools as follows
Logstash – Used to transport and aggregate our metrics from each system into our destination. This destination could be a file or a database or something else. Logstash works on a system of plugins for input, filtering and output. In this case, our input is Collectd and out output is Elasticsearch.
Elastcisearch – Used to store and search our collected metrics. This is our Logstash output.
Kibana – Used to display our metrics stored in Elasticsearch.


data will be collected from collectd data will be written to elasticsearch host and data will be visulized using kibana

Problem Statement: IP address is down/Up need to be monitored

step1 : 
install collectd packages in centos 7 machine

step2:
install ELK server

step3 : 
in config file make neccessary changes like servere ip address and ELK server host name 
vi /etc/collectd.d/collectd.conf

step 4 : 
start the collectd server

systemctl restart collectd.service

step5 : 
start the lotasash server which is listening to collectd port which will write to elasticsearch and create a index

step 6 :
give the index name in Kibana using that index name create a visulisation





