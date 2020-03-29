#!/bin/bash
# Deploy Docker Voting App
##########################
# Create networks
docker network create --driver overlay frontend
docker network create --driver overlay backend

# Creating the voting service:
docker service create --replicas=2 --name vote --network frontend -p 80:80 bretfisher/examplevotingapp_vote

# Creating the redis service:
docker service create --name redis --network frontend redis:3.2

# Creating the worker service:
docker service create --name worker --network frontend --network backend bretfisher/examplevotingapp_worker:java

# Creating the db service:
docker volume create db-data
docker service create --name db --network backend --mount type=volume,source=db-data,target=/var/lib/postgresql/data -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4

# Creating the result service:
docker service create --name result --network backend -p 5001:80 bretfisher/examplevotingapp_result