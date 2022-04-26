FROM perseusdg/cuda_dev:opencv4.5

RUN python3 -m pip install cffi typing_extensions pyyaml mkl mkl-include cmake ninja

ENV CMAKE_PREFIX_PATH /opt/intel/oneapi/mkl/latest:/opt/intel/oneapi/mkl/latest/lib/intel64:${CMAKE_PREFIX_PATH}

RUN export USE_OPENCV=ON && \
    export USE_FFMPEG=ON && \
    export BUILD_ONNX_PYTHON=ON && \
    export USE_NVRTC=ON

RUN mkdir ~/build 

RUN cd ~/build && wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.2.tar.gz && \
tar -xvf magma-2.6.2.tar.gz && cd magma-2.6.2 && mkdir build &&  \
sed -i 's/compute_80/compute_86/g' CMakeLists.txt && \
sed -i 's/sm_80/sm_86/g' CMakeLists.txt && \
sed -i 's/800/860/g' CMakeLists.txt && cd build && \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
-DGPU_TARGET=Ampere -G"Ninja" .. && ninja -j16 install 

RUN cd ~/build && git clone --recursive --depth=1 -b v1.11.0 https://github.com/pytorch/pytorch.git && \
cd pytorch && python3 setup.py install 

RUN cd ~/build && wget https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz && \
tar -xvf v0.12.0.tar.gz && cd vision-0.12.0 && python3 setup.py install 

ENTRYPOINT ["/entrypoint_setup.sh"]
CMD ["terminator"]

