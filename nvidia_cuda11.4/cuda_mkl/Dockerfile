FROM perseusdg/cudagl:cuda11.4-ubuntu20.04


RUN apt-get update && apt-get install -y wget && apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor |tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list && \
apt-get update && \
apt-get install -y intel-oneapi-mkl-devel-2022.0.2 && \
apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo '/opt/intel/oneapi/mkl/latest/lib/intel64' >> /etc/ld.so.conf.d/mkl.conf 
RUN ldconfig