FROM ubuntu:latest

RUN apt-get update -y

RUN apt-get install verilator make g++ -y

RUN apt-get install git \
                  help2man \
                  perl \
                  python3 \
                  libfl2 \
                  libfl-dev \
                  zlib1g \
                  zlib1g-dev \
                  perl-doc \
                  ccache \
                  mold \
                  libgoogle-perftools-dev \
                  numactl \
                  autoconf \
                  flex \
                  bison \
                  clang \
                  clang-format-14 \
                  cmake \
                  gdb \
                  graphviz \
                  lcov \
                  python3-clang \
                  yapf3 \
                  bear \
                  jq -y
