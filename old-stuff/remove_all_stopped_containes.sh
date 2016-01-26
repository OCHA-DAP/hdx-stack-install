# copyleft 2015 teodorescu.serban@gmail.com

for container in $(docker ps -a -f 'status=exited' -q); do
    docker rm $container;
done
