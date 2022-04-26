#taken from nvidia's website
FROM ubuntu:20.04 as base
FROM base as base-amd64


ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.4 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=460,driver<461"
ENV NV_CUDA_CUDART_VERSION 11.4.148-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-11-4

ENV DEBIAN_FRONTEND noninteractive



FROM base-amd64

RUN rm /etc/apt/sources.list
COPY assets/sources.list.princeton /etc/apt/sources.list
RUN apt-get update && apt upgrade -y
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    if [ ! -z ${NV_ML_REPO_ENABLED} ]; then echo "deb ${NV_ML_REPO_URL} /" > /etc/apt/sources.list.d/nvidia-ml.list; fi && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 11.4.4

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-4=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && ln -s cuda-11.4 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN apt-get update && apt-get install -y cuda-toolkit-11-4=11.4.4-1 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
        libglvnd0 libglvnd0:i386 \
        libgl1 libgl1:i386 \
        libglx0 libglx0:i386 \
        libegl1 libegl1:i386 \
        libgles2 libgles2:i386 && \
    rm -rf /var/lib/apt/lists/*

COPY assets/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev libglvnd-dev:i386 \
        libgl1-mesa-dev libgl1-mesa-dev:i386 \
        libegl1-mesa-dev libegl1-mesa-dev:i386 \
        libgles2-mesa-dev libgles2-mesa-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y  libnvinfer-dev=8.2.4-1+cuda11.4 libcudnn8-dev=8.2.4.15-1+cuda11.4 libcudnn8=8.2.4.15-1+cuda11.4 && apt-get clean &&\
rm -rf /var/lib/apt/lists


