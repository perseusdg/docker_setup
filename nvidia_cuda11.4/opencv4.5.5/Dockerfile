FROM perseusdg/cudagl:cuda_11.4.4_mkl

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
python3-dev \
gdb \
gcc g++ \
python3-pip \
unzip libtbb-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*




RUN apt-get update && apt-get install -y --no-install-recommends \
software-properties-common && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository universe 
RUN apt-get update && apt-get install -y python3-pip nasm automake meson python3 openssh-server ssh pyqt5-dev sip-dev && apt-get clean && rm -rf /var/lib/apt/lists/* 
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade virtualenv
RUN pip3 install --upgrade paramiko
RUN pip3 install --ignore-installed --upgrade numpy protobuf

RUN cd ~ && mkdir build
RUN cd ~/build && wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz && \
tar -xvf cmake-3.23.1.tar.gz && cd cmake-3.23.1 && ./configure --prefix=/usr/local --qt-gui --parallel=12 && \
make -j16 && make install 

RUN apt-get update && apt-get install -y libevent-dev libncurses-dev bison

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
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN cd ~/build && wget https://code.videolan.org/videolan/dav1d/-/archive/1.0.0/dav1d-1.0.0.tar.gz && tar -xvf dav1d-1.0.0.tar.gz && \
cd dav1d-1.0.0 && meson build && cd build && ninja -j16 install

RUN cd ~/build && git clone https://gitlab.com/libeigen/eigen.git && cd eigen && \
git checkout 3.3.9 && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -G"Ninja" .. && \
ninja install

RUN apt-get update && apt-get install -y libva-dev libx264-dev libx265-dev libass-dev libtheora-dev libmfx-dev libvulkan-dev libopengl-dev && apt-get clean && rm -rf /var/lib/apt/lists/**

RUN cd ~/build && git clone https://github.com/FFmpeg/nv-codec-headers.git && cd nv-codec-headers && make install

RUN cd ~/build && git clone https://github.com/FFmpeg/FFmpeg.git && cd FFmpeg && git checkout n4.4.2 && \
./configure --prefix=/usr/local --enable-avcodec --enable-avresample --enable-avdevice --enable-avfilter --enable-avformat --enable-swscale --enable-swresample --enable-cuvid --enable-cuda-nvcc --enable-libnpp --enable-libx264 --enable-libx265 --enable-libdav1d --enable-shared --enable-vulkan --enable-opengl --enable-openssl --enable-nonfree --enable-gpl --extra-cflags=-I/usr/local/cuda/include --nvccflags="-gencode arch=compute_86,code=sm_86 -O2" --disable-static --enable-libtheora --enable-libmfx --extra-ldflags="-L/usr/local/cuda/lib64" --enable-nvenc --enable-nvdec --enable-vaapi --enable-libass && \
make -j16 install

RUN cd ~/build && wget https://github.com/Kitware/VTK/archive/refs/tags/v9.1.0.tar.gz && tar -xvf v9.1.0.tar.gz && \
cd VTK-9.1.0 && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DVTK_USE_CUDA=ON \
-DVTK_SMP_IMPLEMENTATION_TYPE=TBB \
-DVTK_GROUP_ENABLE_Imaging=YES \
-DVTK_GROUP_ENABLE_Rendering=YES \
-DVTK_GROUP_ENABLE_Standalone=YES \
-DVTK_GROUP_ENABLE_Views=YES -DVTK_EXTRA_COMPILER_WARNING=ON \
-DCMAKE_INSTALL_PREFIX=/usr/local -G"Ninja" .. && ninja -j16 install


RUN cd ~/build && wget https://github.com/opencv/opencv/archive/4.5.5.tar.gz && tar -xf 4.5.5.tar.gz && rm 4.5.5.tar.gz
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
    -D WITH_LIBV4L=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_TBB=ON \
    ../ && make -j12 && make install && \
    cd python_loader && python3 setup.py install

RUN cd ~/build && git clone https://github.com/jbeder/yaml-cpp.git && cd yaml-cpp && git checkout yaml-cpp-0.7.0 && \
mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
-DYAML_BUILD_SHARED_LIBS=ON -G"Ninja" .. && ninja -j12 && ninja install 

RUN apt-get update && apt-get install apt-transport-https && apt-get update && apt install && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN cd ~ && rm -rf build
RUN cd / && rm -rf build

COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]
CMD ["terminator"]
