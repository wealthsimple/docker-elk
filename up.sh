PROJECT=$(basename $0)

docker-machine start logging-docker

INSTANCE_ID=$(docker-machine ssh logging-docker wget -q -O - http://instance-data/latest/meta-data/instance-id)
VOLUME_ID=$(aws ec2 describe-volumes --filters Name=tag-key,Values="Name" Name=tag-value,Values="Elasticsearch" --query "Volumes[*].VolumeId" | grep -o vol-[a-z0-9]*)

eval $(docker-machine env logging-docker)

aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/sdf # Attach Elastic EBS storage
docker-machine ssh logging-docker "sudo mkdir -p /var/vol && sudo mount /dev/xvdf /var/vol -t ext4"


docker-machine scp -r . logging-docker:$PROJECT # Copy "docker-elk" files to "logging-docker". Deploys new version
PWD=/home/ubuntu/$PROJECT/ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d # Magic
docker-compose logs -f # Check that everything is fine (green log lines)
