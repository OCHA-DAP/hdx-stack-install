# copyleft 2015 teodorescu.serban@gmail.com

for image in $(docker images | grep teodorescuserban | awk '{ print $1 }'); do
    docker rmi $image;
done
