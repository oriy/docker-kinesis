docker-kinesis
==============

Combines Kinesis [mhart/kinesalite](https://github.com/mhart/kinesalite) and DynamoDB [mhart/dynalite](https://github.com/mhart/dynalite)

Image also contains **aws-cli** to allow simpler communication with kinesis

Build docker image

    docker build -t kinesis \
     --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
     --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}\
     --build-arg AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}


Run docker

        docker run --name kinesis -d kinesis

Kinesis service exposed on port **443**. when running docker, you would probably have to map **443** to a different local port (i.e **4567**)

DynamoDB service exposed on port **4568**


### initializing kinesis
Once docker starts running **kinesalite**, an initialization script is executed,
the script `init_kinesis.sh` allows you to create streams in advance before the service starts running.
```
#!/usr/bin/env bash

#
## list all streams to create
#
#declare -a streamNames=(
#  "stream1"
#  "stream2"
#  ...
#  "streamN"
#)
#
#for streamName in "${streamNames[@]}"
#do
#    ./create_stream.sh ${streamName}
#done
#
``` 

### remotely create stream
    docker exec -i kinesis ./create_stream.sh streamname_to_create

### connecting via AWS-cli
    aws --endpoint-url='https://localhost*' --no-verify-ssl kinesis

### configuring Aws objects

#### KCL
```scala
val kinesisClient: AmazonKinesis = AmazonKinesisClientBuilder.standard()
  .withCredentials(credentialsProvider)
  .withEndpointConfiguration(new EndpointConfiguration("localhost:4567", region))
  .build()

val dynamoDBClient: AmazonDynamoDB = AmazonDynamoDBClientBuilder.standard()
  .withCredentials(credentialsProvider)
  .withEndpointConfiguration(new EndpointConfiguration("localhost:4568", region))
  .build()
          
new Worker.Builder()
      .recordProcessorFactory(recordProcessorFactory)
      .config(libConfig)
      .kinesisClient(kinesisClient)
      .dynamoDBClient(dynamoDBClient)
      .build()
```
#### KPL
```scala
new KinesisProducerConfiguration()
      .setRegion(config.region)
      .setCredentialsProvider(CredentialsProvider())
      .setMaxConnections(24)
      .setRequestTimeout(30000)
      .setAggregationEnabled(true)
      .setRecordMaxBufferedTime(config.recordMaxBufferedTime.toMillis)
      .setKinesisEndpoint("localhost")
      .setKinesisPort("4567")
      .setVerifyCertificate(false)
```

