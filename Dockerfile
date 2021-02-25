FROM ubuntu:bionic as base
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    git \
    libproj-dev \
    make \
&& rm -rf /var/lib/apt/lists/*

ENV CXX=g++ \
    PATH=$PATH:/unref/build

WORKDIR /
RUN git clone https://git.immc.ucl.ac.be/unref/unref.git
WORKDIR /unref
RUN git checkout 49951c2 && mkdir build
COPY CMakeLists.txt .
WORKDIR /unref/build
RUN cmake .. && make
