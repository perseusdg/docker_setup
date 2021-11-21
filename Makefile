ifneq (,$(findstring tools_,$(firstword $(MAKECMDGOALS))))
	# use the rest as arguments
	RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
	# ...and turn them into do-nothing targets
	#$(eval $(RUN_ARGS):;@:)
endif


help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

nvidia_ros_noetic:nvidia_ros_noetic ## [NVIDIA] Build ros noetic with cuda11.3 and tensorrt8
		docker build -t perseusdg/ros-noetic:cuda11.3 nvidia_cuda11.3_ros_noetic
		@printf "\n\033[92mDocker Image: perseusdg/ros-noetic:cuda11.3\033[0m\n"


nvidia_ros_foxy:nvidia_ros_foxy ## [NVIDIA] Build ros foxy with cuda11.3 and tensorrt8
		docker build -t perseusdg/ros-foxy:cuda11.3 nvidia_cuda11.3_ros_foxy
		@printf "\n\033[92mDocker Image: perseusdg/ros-foxy:cuda11.3\033[0m\n"

