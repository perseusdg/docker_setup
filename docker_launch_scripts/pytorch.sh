xhost local:root
docker run --rm -it -d --runtime=nvidia --privileged --net=host --ipc=host \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/home/$(id -un)/.Xauthority -e XAUTHORITY=/home/$(id -un)/.Xauthority \
-e DOCKER_USER_NAME=$(id -un) \
-e DOCKER_USER_ID=$(id -u) \
-e DOCKER_USER_GROUP_NAME=$(id -gn) \
-e DOCKER_USER_GROUP_ID=$(id -g) \
-v $HOME/.ssh:/home/$(id -un)/.ssh \
-v $HOME/.vscode:/home/$(id -un)/.vscode \
-v $HOME/.config/Code/User/settings.json:/home/$(id -un)/.config/Code/User/settings.json \
-v $HOME/Datasets:/home/$(id -un)/Datasets \
-v $HOME/docker_development/pytorch_dev:/home/$(id -un)/Development \
-p 8888:8888 \
perseusdg/pytorch:cuda