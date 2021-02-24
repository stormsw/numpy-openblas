FROM debian:buster
RUN apt update && apt-get install build-essential git python3-dev python3-pip gfortran -y
WORKDIR /src
# Part 1. Compile OpenBLAS
ADD https://github.com/xianyi/OpenBLAS/archive/v0.3.13.tar.gz .
RUN gunzip -c v0.3.13.tar.gz | tar xvf -
RUN cd ./OpenBLAS-0.3.13 && \
    make FC=gfortran && \
    make PREFIX=/opt/openblas install && \
    ldconfig /opt/openblas/lib/ && cd ..
# Part 2. Compile NumPy
ADD https://github.com/numpy/numpy/archive/v1.20.1.tar.gz .
RUN gunzip -c v1.20.1.tar.gz | tar xvf -
COPY site.cfg ./numpy-1.20.1/numpy/distutils/site.cfg
RUN apt-get install  -y
RUN cd ./numpy-1.20.1 && \
    pip3 install cython && \
    python3 setup.py build bdist_wheel && \
    pip3 install dist/*.whl && cd ..
# should nt be required
#ENV LD_LIBRARY_PATH /opt/openblas/lib/
COPY test.py .
