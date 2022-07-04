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

nvidia_cudagl_pytorch: nvidia_cudagl_mkl_opencv4 ## Build pytorch with opencv,cuda,torchvision and torchaudio support
		docker build -t perseusdg/pytorch:cuda -f nvidia_cuda11.4/pytorch/Dockerfile  .
		@printf "\n\033[92mDocker Image: perseusdg/pytorch:cuda\033[0m\n" 

nvidia_prebuild_pytorch_tensorrt: ## Build prebuild pytorch container
		docker build -t perseusdg/pytorch:tensorrt -f prebuilt_containers/pytorch/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/pytorch:tensorrt\033[0m\n"

tools_vscode: ## [TOOLS] add vscode to docker container
		docker build --build-arg="ARG_FROM=${RUN_ARGS}" -t ${RUN_ARGS} -f tools/vscode/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/pytorch:cuda\033[0m\n"

nvidia_cudagl_11_6_2: ## [NVIDIA CUDA GL] Build nvidia cuda11.6.2 docker with cudagl
		docker build -t perseusdg/cudagl:cuda11.6-ubuntu20.04 -f nvidia_cuda11.6/base/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/cudagl:cuda11.6-ubuntu20.04\033[0m\n"

nvidia_cudagl_11_6_2_mkl: nvidia_cudagl_11_6_2 ## add mkl to nvidia cuda gl 11.6.2 container
		docker build -t perseusdg/cudagl:cuda_11.6.2_mkl -f nvidia_cuda11.6/mkl/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/cudagl:cuda_11.6.2_mkl\033[0m\n"

nvidia_cudagl_11_6_2_opencv: nvidia_cudagl_11_6_2_mkl ## build opencv nvidia docker with cuda-11.6.2
		docker build -t perseusdg/opencv4.6:cuda11.6 -f nvidia_cuda11.6/opencv4.6/Dockerfile .
		@printf "\n\033[92mDocker Image: perseusdg/opencv4.6:cuda11.6 \033[0m\n"

nvidia_cudagl_pytorch_11_6: nvidia_cudagl_11_6_2_opencv ## Build pytorch with opencv,cuda,torchvision ,xxxx ,torch text and torchaudio support
		docker build -t perseusdg/pytorch:cuda11.6 -f nvidia_cuda11.6/pytorch/Dockerfile  .
		@printf "\n\033[92mDocker Image: perseusdg/pytorch:cuda11.6\033[0m\n" 
