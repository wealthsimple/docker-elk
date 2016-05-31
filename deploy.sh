PROJECT="docker-elk"

echo "pathh!!!"
echo $DOCKER_CERT_PATH

echo "./docker-machine scp -r . logging-docker:$PROJECT"

./docker-machine scp -r . logging-docker:$PROJECT
PWD=/home/ubuntu/$PROJECT/ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --force-recreate
