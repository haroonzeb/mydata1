Private Service Connect

bookmark_border
This document provides an overview of Private Service Connect.

Private Service Connect is a capability of Google Cloud networking that allows consumers to access managed services privately from inside their VPC network. Similarly, it allows managed service producers to host these services in their own separate VPC networks and offer a private connection to their consumers. For example, when you use Private Service Connect to access Cloud SQL, you are the service consumer, and Google is the service producer.

With Private Service Connect, consumers can use their own internal IP addresses to access services without leaving their VPC networks. Traffic remains entirely within Google Cloud. Private Service Connect provides service-oriented access between consumers and producers with granular control over how services are accessed.

Private Service Connect supports access to the following types of managed services:

Published VPC-hosted services, which include the following:
Google published services, such as Apigee or the GKE control plane
Third-party published services provided by Private Service Connect partners
Intra-organization published services, where the consumer and producer might be two different VPC networks within the same company
Google APIs, such as Cloud Storage or BigQuery

![[psc-overview.svg]]