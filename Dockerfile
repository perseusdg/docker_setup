FROM nvidia/cudagl:11.3.1-devel-ubuntu20.04

LABEL maintainer "Harshvardhan Chandirasekar"
LABEL Description="PERSONAL NVIDIA SETUP"
LABEL com.perseusdg.nvidia.version="11.3.1"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
libblkid-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
libcudnn8-dev=8.2.1.32-1+cuda11.3 \
libcudnn8=8.2.1.32-1+cuda11.3 \
libnvinfer-dev=8.0.3-1+cuda11.3 \
libnvinfer8=8.0.3-1+cuda11.3 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
libblkid-dev \
locales \
lsb-release \
mesa-utils \
git \
nano \
terminator \
wget \
curl \
libssl-dev \
htop \
clang-11 \
lldb-11 \
dbus-x11 \
libqt5opengl5-dev \
libgtk-3-dev \
libvtk7-dev \
libv4l-dev \
tar \
gfortran-9 \
libtbb-dev \
libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev \
libdc1394-22-dev \
libavresample-dev \
libatlas-cpp-0.6-dev \
python3-dev \
python3-pip \
unzip libtbb-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
software-properties-common && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository universe 
RUN apt-get update && apt-get install -y python3-pip  python3 openssh-server ssh pyqt5-dev sip-dev && apt-get clean && rm -rf /var/lib/apt/lists/* 
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade virtualenv
RUN pip3 install --upgrade paramiko
RUN pip3 install --ignore-installed --upgrade numpy protobuf


RUN cd ~ && mkdir build
ENV CC clang-11
ENV CXX clang++-11
RUN cd ~/build && wget https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4.tar.gz && export CC=clang-11 && \
export CXX=clang++-11 && tar -xvf cmake-3.21.4.tar.gz && cd cmake-3.21.4 && ./configure --prefix=/usr/local --qt-gui --parallel=12 && \
make -j8 && make install 

RUN apt-get update && apt-get install -y automake autoconf pkg-config libevent-dev libncurses5-dev bison && \
apt-get clean && rm -rf /var/lib/apt/lists/

RUN git clone https://github.com/tmux/tmux.git && \
cd tmux && git checkout tags/3.2 && ls -la && sh autogen.sh && ./configure && make -j8 && make install

RUN apt-get update && apt-get install -y zsh && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN chsh -s /usr/bin/zsh root
RUN git clone https://github.com/sindresorhus/pure /root/.oh-my-zsh/custom/pure
RUN ln -s /root/.oh-my-zsh/custom/pure/pure.zsh-theme /root/.oh-my-zsh/custom/
RUN ln -s /root/.oh-my-zsh/custom/pure/async.zsh /root/.oh-my-zsh/custom/
RUN sed -i -e 's/robbyrussell/refined/g' /root/.zshrc
RUN sed -i '/plugins=(/c\plugins=(git git-flow adb pyenv tmux)' /root/.zshrc

RUN mkdir -p /root/.config/terminator/
COPY assets/terminator_config /root/.config/terminator/config 

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf


ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/lib:/usr/lib/x86_64-linux-gnu:/usr/local/lib:${LD_LIBRARY_PATH}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics



RUN cd ~/build && wget https://github.com/opencv/opencv/archive/4.5.4.tar.gz && tar -xf 4.5.4.tar.gz && rm 4.5.4.tar.gz
RUN cd ~/build && wget https://github.com/opencv/opencv_contrib/archive/4.5.4.tar.gz && tar -xf 4.5.4.tar.gz && rm 4.5.4.tar.gz
RUN cd ~/build && \
    cd opencv-4.5.4 && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D CMAKE_C_COMPILER=clang-11 \
    -D CMAKE_CXX_COMPILER=clang++-11 \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH='~/build/opencv_contrib-4.5.4/modules' \
    -D BUILD_EXAMPLES=OFF \
    -D WITH_CUDA=ON \
    -D WITH_OPENGL=ON \
    -D CUDA_ARCH_BIN=6.1 \
    -D CUDA_ARCH_PTX=6.1 \
    -D ENABLE_FAST_MATH=ON \
    -D CUDA_FAST_MATH=ON \
    -D WITH_CUBLAS=ON \
    -D WITH_CUDNN=ON \
    -D WITH_OPENMP=ON \
    -D WITH_NONFREE=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_TBB=ON \
    ../ && make -j12 && make instal

RUN cd ~ && rm -rf build
COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]
CMD ["terminator"]



