FROM dev/cudagl:12_1_1 

RUN apt-get update && apt-get install -y wget && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor |tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" |tee /etc/apt/sources.list.d/oneAPI.list
RUN apt-get update && \
apt-get install -y intel-oneapi-mkl-devel-2023.1.0  \
intel-oneapi-tbb-devel-2021.9.0 && \
apt-get clean && rm -rf  /var/lib/apt/lists/* 

RUN echo '/opt/intel/oneapi/mkl/latest/lib/intel64:/opt/intel/oneapi/tbb/latest/lib/intel64/gcc4.8' >> /etc/ld.so.conf.d/mkl.conf 

RUN cp /opt/intel/oneapi/mkl/latest/lib/pkgconfig/* /usr/share/pkgconfig/
RUN cp /opt/intel/oneapi/tbb/latest/lib/pkgconfig/* /usr/share/pkgconfig/

ENV PKG_CONFIG_PATH /opt/intel/oneapi/mkl/latest/lib/pkgconfig/:/opt/intel/oneapi/tbb/latest/lib/pkgconfig/:${PKG_CONFIG_PATH}

RUN ldconfig
