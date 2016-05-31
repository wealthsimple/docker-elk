PROJECT="docker-elk"

./docker-machine scp -r . logging-docker:$PROJECT
PWD=/home/ubuntu/$PROJECT/ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --force-recreate
