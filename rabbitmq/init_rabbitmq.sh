#!/bin/bash
#reset first node
echo "Reset first rabbitmq node."
docker exec -it rabbitmq01 /bin/bash -c 'rabbitmqctl stop_app'
docker exec -it rabbitmq01 /bin/bash -c 'rabbitmqctl reset'
docker exec -it rabbitmq01 /bin/bash -c 'rabbitmqctl start_app'
# build cluster(参数--ram表示设置为内存节点，忽略该参数默认为磁盘节点)
echo "Starting to build rabbitmq cluster with two ram nodes."
docker exec -it rabbitmq02 /bin/bash -c 'rabbitmqctl stop_app'
docker exec -it rabbitmq02 /bin/bash -c 'rabbitmqctl reset'
docker exec -it rabbitmq02 /bin/bash -c 'rabbitmqctl join_cluster --ram rabbit@rabbitmq01'
docker exec -it rabbitmq02 /bin/bash -c 'rabbitmqctl start_app'
docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl stop_app'
docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl reset'
docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl join_cluster --ram rabbit@rabbitmq01'
docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl start_app'
#check cluster status
echo "Check cluster status:"
docker exec rabbitmq01 /bin/bash -c 'rabbitmqctl cluster_status'
docker exec rabbitmq02 /bin/bash -c 'rabbitmqctl cluster_status'
docker exec rabbitmq03 /bin/bash -c 'rabbitmqctl cluster_status'
