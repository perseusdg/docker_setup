FROM nvcr.io/nvidia/pytorch:22.04-py3

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt upgrade -y 
RUN apt-get update && apt install -y \
libnvinfer-dev libeigen3-dev \
libvtk7-qt-dev gedit libgtk-3-dev \
libqt5opengl5-dev libyaml-cpp-dev libjsoncpp-dev

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y --no-install-recommends \
        libglvnd0 libglvnd0:i386 \
        libgl1 libgl1:i386 \
        libglx0 libglx0:i386 \
        libegl1 libegl1:i386 \
        libgles2 libgles2:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev libglvnd-dev:i386 \
        libgl1-mesa-dev libgl1-mesa-dev:i386 \
        libegl1-mesa-dev libegl1-mesa-dev:i386 \
        libgles2-mesa-dev libgles2-mesa-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libcudnn8-dev libtbb-dev clang lld lldb 

RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor |tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list && \
apt-get update && \
apt-get install -y intel-oneapi-mkl-devel-2022.0.2 && \
apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo '/opt/intel/oneapi/mkl/latest/lib/intel64' >> /etc/ld.so.conf.d/mkl.conf 
RUN ldconfig

RUN apt-get update && apt-get install -y --no-install-recommends \
libblkid-dev \
locales \
lsb-release \
mesa-utils \
git \
nano gcc g++ \
terminator \
wget \
curl \
libssl-dev \
htop \
dbus-x11 \
libqt5opengl5-dev \
libgtk-3-dev \
libv4l-dev \
tar \
libgoogle-glog-dev \
libgflags-dev \
gfortran \
libtbb-dev \
libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev \
libdc1394-22-dev \
libatlas-cpp-0.6-dev \
gdb \
gcc g++ \
unzip libtbb-dev libmfx-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf


ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/lib:/usr/lib/x86_64-linux-gnu:/usr/local/lib:${LD_LIBRARY_PATH}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN mkdir ~/build && cd ~/build && wget https://github.com/opencv/opencv/archive/4.5.5.tar.gz && tar -xf 4.5.5.tar.gz && rm 4.5.5.tar.gz
RUN cd ~/build && wget https://github.com/opencv/opencv_contrib/archive/4.5.5.tar.gz && tar -xf 4.5.5.tar.gz && rm 4.5.5.tar.gz
RUN cd ~/build && \
    cd opencv-4.5.5 && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH='~/build/opencv_contrib-4.5.5/modules' \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_DOCS=OFF \
    -D WITH_MKL=ON \
    -D WITH_MFX=ON \
    -D MKL_ROOT_DIR=/opt/intel/oneapi/mkl/latest \
    -D MKL_WITH_TBB=ON \
    -D MKL_WTH_OPENMP=ON \
    -D WITH_CUDA=ON \
    -D WITH_OPENGL=ON \
    -D WITH_EIGEN=ON \
    -D WITH_NVCUVID=ON \
    -D CUDA_ARCH_BIN=8.6 \
    -D CUDA_ARCH_PTX=8.6 \
    -D ENABLE_FAST_MATH=ON \
    -D CUDA_FAST_MATH=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDNN=ON \
    -D WITH_OPENMP=ON \
    -D WITH_NONFREE=ON \
    -D WITH_PYTHON=OFF \
    -D WITH_LIBV4L=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_TBB=ON \
    ../ && make -j12 && make install

RUN apt-get update && apt-get install -y openssh-server
COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]
CMD ["terminator"]