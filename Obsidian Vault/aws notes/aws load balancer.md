Hi [@Anton Kreuzstein](https://quorumio.slack.com/team/U01701YRNLC) I encountered an issue while configuring the GitHub runner, and to resolve this, please recreate the GitHub runner registration token for me because token is expire . I've attached screenshots of the errors I encountered for your reference, which should help in understanding the situation better. (edited)
#### Network Load Balancer

When compared to an Application Load Balancer a simple explanation goes like this: Network Load Balancer is used anywhere where the application behind the balancer doesn't work over HTTP(S), but uses some other protocol. Including, but not limited to:

- Legacy applications that implement custom protocol.
- NTP servers.
- SMTP server.
- Database servers.
- MQTT brokers.
- High performance queue servers (ActiveMQ, RabbitMQ, ZeroMQ etc.).
- Message processing applications (think Kafka and Co.).

NLB provides **static IP** address, ALB does not. So use it when you require a static IP for your LB. Similarly, it is the only balancer that can use **Elastic IP addresses**.
    
 Use NLB when you require **end-to-end SSL encryption**. ALB will always terminate SSL connection, which may be not desired due to strict security requirements.
    
NLB is the only balancer type that can be used for API Gateway [VpcLink](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-private-integration.html) or [VPC PrivateLink](https://docs.aws.amazon.com/vpc/latest/userguide/endpoint-service.html) technologies.
    
NLB does not have Security Groups.

![[Pasted image 20240701170728.png]]


application load balancer

![[Pasted image 20240701185150.png]]



gateway load balancer

![[Pasted image 20240701184940.png]]