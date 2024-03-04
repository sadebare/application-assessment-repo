#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo aws ecr get-login-password --region us-west-2 | sudo docker login --username AWS --password-stdin 851725214577.dkr.ecr.us-west-2.amazonaws.com

sudo docker pull 851725214577.dkr.ecr.us-west-2.amazonaws.com/java-app:latest

sudo docker run -dp 8080:8080 851725214577.dkr.ecr.us-west-2.amazonaws.com/java-app:latest