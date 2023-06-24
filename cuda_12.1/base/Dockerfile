#Take from nvidia's website
FROM ubuntu:22.04 as base
FROM base as base-amd64 

ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=12.1 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=510,driver<511 brand=unknown,driver>=510,driver<511 brand=nvidia,driver>=510,driver<511 brand=nvidiartx,driver>=510,driver<511 brand=geforce,driver>=510,driver<511 brand=geforcertx,driver>=510,driver<511 brand=quadro,driver>=510,driver<511 brand=quadrortx,driver>=510,driver<511 brand=titan,driver>=510,driver<511 brand=titanrtx,driver>=510,driver<511 brand=tesla,driver>=515,driver<516 brand=unknown,driver>=515,driver<516 brand=nvidia,driver>=515,driver<516 brand=nvidiartx,driver>=515,driver<516 brand=geforce,driver>=515,driver<516 brand=geforcertx,driver>=515,driver<516 brand=quadro,driver>=515,driver<516 brand=quadrortx,driver>=515,driver<516 brand=titan,driver>=515,driver<516 brand=titanrtx,driver>=515,driver<516 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526 brand=geforce,driver>=530,driver<535 brand=geforcertx,driver>=530,driver<535"
ENV NV_CUDA_CUDART_VERSION 12.1.105-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-12-1

ENV DEBIAN_FRONTEND noninteractive

FROM base-amd64

RUN apt-get update && apt upgrade -y


RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/${NVARCH}/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 12.1.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-1=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics

RUN apt-get update && apt-get install -y cuda-toolkit-12.1=12.1.1-1  && apt-get clean && rm -rf /var/lib/apt/lists/* 

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

RUN apt-get update && apt-get install -y --no-install-recommends \
        libnvinfer8=8.6.1.6-1+cuda12.0 \
        libnvinfer-dev=8.6.1.6-1+cuda12.0 \
        libnvinfer-plugin-dev=8.6.1.6-1+cuda12.0 \
        libnvinfer-plugin8=8.6.1.6-1+cuda12.0 \
        libnvinfer-bin=8.6.1.6-1+cuda12.0 \
        libnvinfer-vc-plugin-dev=8.6.1.6-1+cuda12.0 \
        libnvinfer-vc-plugin8=8.6.1.6-1+cuda12.0 \
        libnvparsers-dev=8.6.1.6-1+cuda12.0 \
        libnvparsers8=8.6.1.6-1+cuda12.0 \
        libnvonnxparsers-dev=8.6.1.6-1+cuda12.0 \
        libnvonnxparsers8=8.6.1.6-1+cuda12.0 \
        libcudnn8=8.9.0.131-1+cuda12.1 \
        libcudnn8-dev=8.9.0.131-1+cuda12.1 && \
        rm -rf /var/lib/apt/lists/*
        