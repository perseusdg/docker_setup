FROM perseusdg/opencv4.6:cuda11.6

RUN python3 -m pip install cffi typing_extensions pyyaml mkl mkl-include cmake ninja
ENV CMAKE_PREFIX_PATH /opt/intel/oneapi/mkl/latest:${CMAKE_PREFIX_PATH}

RUN mkdir ~/build && cd ~/build && wget http://icl.utk.edu/projectsfiles/magma/downloads/magma-2.6.2.tar.gz && \
tar -xvf magma-2.6.2.tar.gz && cd magma-2.6.2 && mkdir build &&  \
sed -i 's/compute_80/compute_86/g' CMakeLists.txt && \
sed -i 's/sm_80/sm_86/g' CMakeLists.txt && \
sed -i 's/800/860/g' CMakeLists.txt && cd build && \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
-DGPU_TARGET=Ampere -G"Ninja" .. && ninja -j12 install 

RUN apt-get update && apt install -y python-is-python3
RUN cd ~/build && git clone --recursive -b v1.12.0 https://github.com/pytorch/pytorch.git && cd pytorch && \
USE_OPENCV=ON USE_FFMPEG=ON BUILD_ONNX_PYTHON=ON USE_TBB=ON TORCH_CUDA_ARCH_LIST="8.6+PTX" python setup.py build --cmake-only && \
cd build && ninja -j12 && cd .. && USE_OPENCV=ON USE_FFMPEG=ON BUILD_ONNX_PYTHON=ON USE_TBB=ON TORCH_CUDA_ARCH_LIST="8.6+PTX"  python3 setup.py install && \
mkdir build_libtorch && cd build_libtorch && cmake -DCMAKE_BUILD_TYPE=Release -DUSE_OPENCV=ON -DUSE_FFMPEG=ON -DUSE_TBB=ON -DBUILD_PYTHON=OFF -DCMAKE_INSTALL_PREFIX=/usr/local -DTORCH_CUDA_ARCH_LIST="8.6+PTX" -G"Ninja" .. && \
ninja -j12 && ninja install

RUN export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/x86_64-linux-gnu"
RUN cp /usr/local/lib/x86_64-linux-gnu/lib* /usr/local/lib/

RUN cd ~/build && git clone --recursive -b v0.13.0 https://github.com/pytorch/text.git && cd text &&  python setup.py install && mkdir build_libtorch && cd build_libtorch && \
cmake -DCMAKE_BUILD_TYPE=Release -G"Ninja" ..  && ninja -j8 install 

RUN cd ~/build && git clone --recursive -b v0.12.0 https://github.com/pytorch/audio.git && cd audio && python setup.py install && mkdir build_libtorch && cd build_libtorch && \
cmake -DCMAKE_BUILD_TYPE=Release -G"Ninja" .. && ninja -j8 install 


RUN apt-get update && apt-get install -y libjpeg-dev 

RUN cd ~/build && git clone --recursive -b v0.13.0 https://github.com/pytorch/vision.git && cd vision && python setup.py install && mkdir build_libtorch && cd build_libtorch && \
cmake -DCMAKE_BUILD_TYPE=Release -G"Ninja" .. && ninja -j8 install 

RUN rm -rf ~/build

RUN pip3 install jupyter pandas jupyterlab scipy pillow tqdm matplotlib pyside2

ENTRYPOINT ["/entrypoint_setup.sh"]
CMD ["terminator"]