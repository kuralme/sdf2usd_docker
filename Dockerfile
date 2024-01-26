FROM ros:rolling-ros-core-jammy
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y upgrade && apt install -y \
    build-essential apt-utils cmake git wget\
    libpyside2-dev \
    python3-opengl \
    libglu1-mesa-dev \
    freeglut3-dev \
    mesa-common-dev

RUN git clone --depth 1 -b v22.11 https://github.com/PixarAnimationStudios/USD.git
RUN python3 /USD/build_scripts/build_usd.py --build-variant release --no-tests --no-examples --no-tutorials --no-docs --no-python /usr/local/USD

ENV PATH="/usr/local/USD/bin:$PATH" 
ENV LD_LIBRARY_PATH="/usr/local/USD/lib:$LD_LIBRARY_PATH"
ENV CMAKE_PREFIX_PATH="/usr/local/USD:$CMAKE_PREFIX_PATH"

# TODO gz-cmake3 and sdf13 install - not working yet
# RUN git clone https://github.com/gazebosim/gz-cmake
# WORKDIR /gz-cmake/build
# RUN cmake .. && make install
# RUN apt-get update && apt-get -y install \
    # libsdformat13-dev \
    # libsdformat13

RUN apt-get update && apt-get -y install \
    libsdformat12-dev \
    libsdformat12 \
    libignition-utils1-cli-dev \
    libignition-common-dev || true
# RUN apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone -b ahcorde/fix/usd2sdf_model https://github.com/gazebosim/gz-usd
RUN rm /gz-usd/src/sdf_parser/Geometry.cc
COPY /fix/Geometry.cc /gz-usd/src/sdf_parser/
WORKDIR /gz-usd/build
RUN cmake .. && make -j4

RUN echo 'alias sdf2usd="/gz-usd/build/bin/sdf2usd"' >> ~/.bashrc
RUN echo 'alias usd2sdf="/gz-usd/build/bin/usd2sdf"' >> ~/.bashrc
WORKDIR /userfiles
