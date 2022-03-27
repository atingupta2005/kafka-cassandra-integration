# Kafka and Cassandra Integration
- Refer:
  -
  - https://www.datastax.com/dev/kafka#introduction

- Clone Repo
```
git clone https://github.com/atingupta2005/kafka-cassandra-integration
cd kafka-cassandra-integration
```

- Create table in Cassandra
```
cqlsh
SOURCE 'users.cql'
EXIT
```
- Create topic in Kafka
```
kafka_2.12-2.5.0/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic demo --config retention.ms=-1
```

- Get Kafka Connector
```
wget https://downloads.datastax.com/kafka/kafka-connect-cassandra-sink-1.4.0.tar.gz
tar -xzf kafka-connect-cassandra-sink-1.4.0.tar.gz
```

- Move our version of the file over to the Kafka /config directory to over write the default.
```
mv connect-standalone.properties kafka_2.12-2.5.0/config
```

- Upon starting the Kafka connect worker, a persistent Java process is created that reads either the configuration file.
- This points to where the kafka-connect-cassandra-sink-1.4.0.jar is located.

- The cassandra-sink-standalone.properties holds important DataStax Apache Kafka™ Connector parameters

- We have provided you with a version of cassandra-sink that has already been configured. Move it into the connector configuration folder, it will overwrite the default file there.
```
mv cassandra-sink-standalone.properties kafka-connect-cassandra-sink-1.4.0/conf
```

- Start the Kafka worker
```
kafka_2.12-2.5.0/bin/connect-standalone.sh kafka_2.12-2.5.0/config/connect-standalone.properties kafka-connect-cassandra-sink-1.4.0/conf/cassandra-sink-standalone.properties &> standalone-mode.log &
```

## Generating the User Data
- The kafka-console-producer is a command line client that comes with Kafka. It will take input from a file or from standard input and send it out as messages to the Kafka cluster
- We are now going to generate some test data. We can do this using the kafka-console-producer utility. Here's an input file of user data. Each line of data contains the lastname as the key, i.e.Marks and the JSON payload as the value:
```
{
    "lastname": "Marks",
    "firstname": "Timothy",
    "email": "timothy@example.com"
}
```

- Pipe the contents of user.txt to the producer, providing the connection information, topic, and a description of the key/value formatting of each line:
```
cat users.txt | kafka_2.12-2.5.0/bin/kafka-console-producer.sh \
  --broker-list localhost:9092 \
  --topic demo \
  --property "parse.key=true" \
  --property "key.separator=:"; sleep 10;
```

## Viewing the Inserted Data
```
cqlsh
SELECT * FROM demo.users;
```
