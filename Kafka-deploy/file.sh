#! /bin/bash
sudo su
sudo apt update --yes
sudo apt install openjdk-8-jdk --yes
mkdir Downloads
sudo curl "https://archive.apache.org/dist/kafka/2.8.1/kafka_2.12-2.8.1.tgz" -o /Downloads/kafka.tgz
sudo mkdir /kafka && cd /kafka
sudo tar -xvzf /Downloads/kafka.tgz --strip 1
echo "listeners=PLAINTEXT://kafkaserver.hackfse.argupta.xyz:9092" >> config/server.properties
echo "advertised.listeners=PLAINTEXT://kafkaserver.hackfse.argupta.xyz:9092" >> config/server.properties
sudo bin/zookeeper-server-start.sh config/zookeeper.properties&
sudo bin/kafka-server-start.sh config/server.properties&
sudo bin/kafka-topics.sh -zookeeper localhost:2181 -topic TweetMessage --create --partitions 3 --replication-factor 1&