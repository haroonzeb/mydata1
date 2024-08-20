
### elastic search architecture: 
cluster and nodes :
Elasticsearch is a distributed, RESTful search and analytics engine designed for horizontal scalability, reliability, and real-time search capabilities. Its architecture consists of several key components that work together to provide these features:
 data store= json
 data store=  json +metadata
 keys start from "_index"  "_source"
 document= row in sql
 fields=columns in sql
 index=table in sql
   
  

1. Cluster
Definition: A cluster is a collection of one or more nodes (servers) that together hold all the data and provide federated indexing and search capabilities.
Purpose: Ensures data redundancy and high availability. It can scale horizontally by adding more nodes.
2. Node
Definition: A single instance of Elasticsearch, running on a physical or virtual machine.
Types:
Master Node: Manages cluster-wide settings and operations like creating or deleting indices, tracking nodes, and allocating shards.
Data Node: Stores data and executes data-related operations like search and aggregation.
Ingest Node: Preprocesses documents before indexing them.
Coordinating Node: Routes requests to the appropriate data nodes, handles search requests, and aggregates results.
3. Index
Definition: A collection of documents that share similar characteristics. It is similar to a database in an RDBMS.
Structure: Each index is divided into shards, and each shard can have multiple replicas.
4. Document
Definition: The basic unit of information that can be indexed. Each document is a JSON object.
Fields: Each document consists of fields, which can hold data such as text, numbers, dates, or binary data.
5. Shards
Definition: Subdivisions of an index that allow it to be distributed across multiple nodes.
Primary Shards: Original shards of the index.
Replica Shards: Copies of primary shards, providing redundancy and high availability.
6. Routing and Allocation
Routing: Determines how documents are distributed across shards. It uses the document's unique ID to determine which shard will contain the document.
Allocation: The process of distributing shards across the nodes in a cluster, managed by the master node.
7. Lucene
Definition: The underlying search library that Elasticsearch uses for indexing and search capabilities.
Role: Handles low-level indexing and querying processes, such as tokenizing text and scoring search results.
8. API Interface
RESTful API: Elasticsearch provides a powerful REST API to interact with the cluster. Common operations include:
Indexing documents (POST /index/_doc)
Searching documents (GET /index/_search)
Managing indices (PUT /index, DELETE /index)
9. Plugins
Definition: Extensions that add custom functionality to Elasticsearch.
Examples: Security plugins, analysis plugins, and monitoring tools.
10. Kibana and Logstash
Kibana: A visualization tool for Elasticsearch. It allows users to create dashboards and visualizations based on Elasticsearch queries.
Logstash: A data processing pipeline that ingests data from various sources, transforms it, and sends it to Elasticsearch.
Data Flow in Elasticsearch
Ingest: Data is ingested through APIs or Logstash, possibly preprocessed by ingest nodes.
Indexing: Data is indexed and stored in shards across data nodes.
Searching: Search requests are sent to coordinating nodes, which route them to the appropriate data nodes. Results are aggregated and returned to the user.
High Availability and Scalability
Replication: Each primary shard can have multiple replica shards for fault tolerance.
Load Balancing: Requests are distributed across nodes to balance the load.
Scalability: Adding more nodes can horizontally scale the cluster, increasing capacity and performance.
Understanding these components and their interactions is crucial for designing and maintaining a robust Elasticsearch deployment, ensuring efficient data management, high availability, and responsive search performance.
