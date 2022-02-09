ifneq (,$(findstring tools_,$(firstword $(MAKECMDGOALS))))
	# use the rest as arguments
	RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
	# ...and turn them into do-nothing targets
	#$(eval $(RUN_ARGS):;@:)
endif


help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

nvidia_dev_cuda11_4:nvidia_dev_cuda11_4 ## [NVIDIA] Build ros noetic with cuda11.3 and tensorrt8
		docker build -t perseusdg/nvidia_dev:cuda11.4 nvidia_cuda11.4_dev
		@printf "\n\033[92mDocker Image: perseusdg/nvidia_dev:cuda11.4\033[0m\n"


nvidia_ros_foxy:nvidia_ros_foxy ## [NVIDIA] Build ros foxy with cuda11.3 and tensorrt8
		docker build -t perseusdg/ros-foxy:cuda11.3 nvidia_cuda11.3_ros_foxy
		@printf "\n\033[92mDocker Image: perseusdg/ros-foxy:cuda11.3\033[0m\n"


pytorch_cuda11_3:pytorch_cuda11_3  ## [NVIDIA] pytorch with cuda11.3
		docker build -t perseusdg/pytorch:cuda11.3 nvidia_cuda11.3_pytorch
		@printf "\n\033[92mDocker Image: perseusdg/pytorch:cuda11.3\033[0m\n"


