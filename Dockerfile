FROM ubuntu:bionic as base
RUN apt-get update \
&&  apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    g++ \
    git \
    libproj-dev \
    make \
&&  rm -rf /var/lib/apt/lists/* \

ENV CXX=g++ \
    PATH=$PATH:/opt/local/bin

# clone unref repo and get correct version
# make directories
WORKDIR /
RUN git clone https://git.immc.ucl.ac.be/unref/unref.git \
&&  mkdir /unref/build \
&&  mkdir -p /opt/local/bin

#compile and install
WORKDIR /unref/build
COPY CMakeLists.txt ..
RUN git checkout 49951c2 \
&&  cmake .. \
&&  make \
&&  mv unref /opt/local/bin

# clean
WORKDIR /inputs
RUN apt-get remove -y \
    cmake \
    git \
    libproj-dev \
    make \
&&  rm -rf /var/lib/apt/lists/* \
&&  rm -rf /unref
