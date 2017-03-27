from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk, streaming_bulk

from datetime import datetime
import sys


class ElasticSearch(object):
	def __init__(self):
		#self.es = Elasticsearch( ['localhost:9200'])
		#self.es =Elasticsearch(host=[{"host" : "localhost", "port" : 9200}])
		ES_HOST = {"host" : "localhost", "port" : 9200}
		self.es = Elasticsearch(hosts = [ES_HOST])


	def list_indices(self):
		"""
		List all the indexes and count of index
		"""
		list_indices = self.es.indices.get_alias().keys()
		print "Number of indexes {}" .format(len(list_indices))
		return sorted(list_indices)

	def list_of_index_starts_with(self,index_name):
		"""
		List all the index which starts with arguement passed
		"""
		print self.list_indices()
		query_string = index_name
		print "There are {} documents found which starts with:{}".format(len([index for index in self.es.indices.get(query_string+"*")]),query_string)
		print "Those are {} ".format([index for index in self.es.indices.get(query_string+"*")])


	def delete_index(self,index_name):
		"""
		Delete the index whcih is passed as a arguement.
		"""
		if self.es.indices.exists(index=index_name):
			print self.es.indices.delete(index=index_name, ignore=[400, 404])
			print "Index is deleted {} ".format(index_name)
		else :
			print "index is already deleted or index not exists"
	

	def delete_index_all(self,index_name):
		"""
		Delete all the index which starts with passed arguement
		it will match all index which starts with index_name and delete
		"""
		print self.list_indices()
		if self.es.indices.exists(index=index_name+'*'):
			#print self.es.indices.delete(index=index_name, ignore=[400, 404])
			print self.es.indices.delete(index=index_name+'*', ignore=[400, 404])
			print "Index is deleted {} ".format(index_name+'*')
		else :
			print "index is already deleted or index not exists"

	def get_mapping(self,index_name):
		"""
		For the given index it will display the mapping means schema of a index
		"""
		if self.es.indices.exists(index=index_name):
			print self.es.indices.get_mapping(index=index_name).get(index_name)
		else:
			print "Index {} not found".format(index_name)

	def search_index(self,index_name):
		"""
		Search index document
		"""
		print "Searching {}".format(index_name)
		search_result = self.es.search(index = index_name, size=1, body={"query": {"match_all": {}}})
		#print(" response: '%s'" % (search_result))
		for hit in search_result['hits']['hits']:
			print(hit["_source"])

	def create_index(self,index_name,doc_type,index,bulk_data):
		print("bulk indexing...")
		self.es.index(index = index_name, doc_type=doc_type,id=index,body = bulk_data,ignore=[400, 404])
		

	def get_index_count_stastics(self,index_name):
		"""
		Display the number of document in the index 
		Dispaly the index stastics
		"""
		print "Number of records in the index-->"
		print self.es.count(index=index_name).get('count')
		# res = es.search(index = index_name, size=2, body={"query": {"match_all": {}}})
		# size=res['hits']['total']
		# print size
		print "Index Stastics-->"
		print self.es.indices.get(index=index_name)


	def get_cluster_status(self):
		"""
		Check weather elasticsearch is up/Down.
		Dispaly the cluster health
		"""
		print "check the elastic is up or not-->"
		if self.es.ping():
			print "Elasticsearch is up"
		else :
			print "Elasticsearch is Down"
		print "cluster health-->"
		print(self.es.cluster.health())

	
es_obj = ElasticSearch()
# print es_obj.list_indices()
# es_obj.list_of_index_starts_with("test_index")
# es_obj.delete_index_all("filebeat_its_grok_only")
#es_obj.delete_index('filebeat_its_evening-2017.02.23')
#es_obj.get_mapping('its_filebeat_tomcat_both-2017.03.22')
#es_obj.get_cluster_status()
#es_obj.get_indices('collectd-ipm-2017.03.26')
#es_obj.get_mapping('heartbeat-2017.03.23')
es_obj.search_index('test_index3')
# es_obj.create_index("test_index3","test_type_index1",2, {'name':'yogesh','age':'25'})
