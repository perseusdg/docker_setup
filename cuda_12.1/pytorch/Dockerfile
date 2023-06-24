FROM dev/cudagl:opencv-4.7

ENV CMAKE_PREFIX_PATH /opt/intel/oneapi/mkl/latest:/opt/intel/oneapi/tbb/latest/:${CMAKE_PREFIX_PATH}

RUN cd ~/build && wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.7.1.tar.gz && \
tar -xvf magma-2.7.1.tar.gz && cd magma-2.7.1 && mkdir build &&  \
sed -i 's/compute_80/compute_86/g' CMakeLists.txt && \
sed -i 's/sm_80/sm_86/g' CMakeLists.txt && \
sed -i 's/800/860/g' CMakeLists.txt && cd build && \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
-DGPU_TARGET=Ampere -G"Ninja" .. && ninja -j12 install 


RUN cd ~/build && git clone --recursive -b v2.0.1 https://github.com/pytorch/pytorch.git 
RUN cd ~/build/pytorch && \
USE_OPENCV=ON USE_FFMPEG=ON BUILD_ONNX_PYTHON=ON USE_TBB=ON TORCH_CUDA_ARCH_LIST="8.6+PTX" python3 setup.py build --cmake-only && \
cd build && ninja -j12 && cd .. && USE_OPENCV=ON USE_FFMPEG=ON BUILD_ONNX_PYTHON=ON USE_TBB=ON TORCH_CUDA_ARCH_LIST="8.6+PTX"  python3 setup.py install && \
mkdir build_libtorch && cd build_libtorch && cmake -DCMAKE_BUILD_TYPE=Release -DUSE_OPENCV=ON -DUSE_FFMPEG=ON -DUSE_TBB=ON -DBUILD_PYTHON=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DTORCH_CUDA_ARCH_LIST="8.6+PTX" -G"Ninja" .. && \
ninja -j12 && ninja install

RUN export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/x86_64-linux-gnu"
RUN python3 -m pip install sympy
ENV LD_LIBRARY_PATH /usr/local/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}
RUN cp /usr/local/lib/x86_64-linux-gnu/lib* /usr/local/lib/
ENV PKG_CONFIG_PATH /opt/intel/oneapi/mkl/latest/lib/pkgconfig/:/opt/intel/oneapi/tbb/latest/lib/pkgconfig/:${PKG_CONFIG_PATH}
RUN cp /opt/intel/oneapi/mkl/latest/lib/intel64/lib* /usr/local/lib/

RUN cd ~/build && git clone --recursive --depth=1 -b v0.15.2 https://github.com/pytorch/vision.git && cd vision && python3 setup.py install && mkdir build_libtorch && cd build_libtorch && \
cmake -DCMAKE_BUILD_TYPE=Release -G"Ninja" .. && ninja -j8 install 