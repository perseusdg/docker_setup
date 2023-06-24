xhost local:root
docker run --rm -it -d --runtime=nvidia --privileged --net=host --ipc=host \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
-v $HOME/.ssh:/root/.ssh \
-v $HOME/docker_development/pytorch_dev:/root/Development \
-p 8888:8888 \
dev/cudagl:opencv-4.7