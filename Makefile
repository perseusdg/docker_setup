ifneq (,$(findstring tools_,$(firstword $(MAKECMDGOALS))))
	# use the rest as arguments
	RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
	# ...and turn them into do-nothing targets
	#$(eval $(RUN_ARGS):;@:)
endif


help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

nvidia_cudagl_11_4_4: ## [NVIDIA CUDA GL] Build nvidia cuda 11.4.4 with cudagl
		docker build -t perseusdg/cudagl:cuda11.4-ubuntu20.04 -f nvidia_cuda11.4/base/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/cudagl:cuda11.4-ubuntu20.04\033[0m\n"
nvidia_cudagl_11_4_4_mkl: nvidia_cudagl_11_4_4 ## Build nvidia cudagl 11.4.4 with intel oneapi mkl support
		docker build -t perseusdg/cudagl:cuda_11.4.4_mkl -f nvidia_cuda11.4/cuda_mkl/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/cudagl:cuda_11.4.4_mkl\033[0m\n"

nvidia_cudagl_mkl_opencv4: nvidia_cudagl_11_4_4_mkl ## Build opencv 4.5.5 with mkl and cuda
		docker build -t perseusdg/cuda_dev:opencv4.5 -f nvidia_cuda11.4/opencv4.5.5/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/cuda_dev:opencv4.5\033[0m\n"