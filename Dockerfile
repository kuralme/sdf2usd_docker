FROM ros:rolling-ros-core-jammy

RUN apt update -y && apt -y upgrade && apt install -y \
    wget curl unzip git zsh vim ffmpeg fzf apt-utils \
    python3-dev python3 python3-pip python3-venv python3-opengl \
    libgl1-mesa-dev libgl1-mesa-glx libglew-dev libosmesa6-dev patchelf swig \
    xvfb libglfw3-dev libosmesa-dev
RUN apt clean && rm -rf /var/lib/apt/lists/*

# RUN apt update && apt install --no-install-recommends -y \
#     build-essential \
#     git \
#     libsdformat12-dev \
#     libignition-utils1-cli-dev \
#     libpyside2-dev \
#     python3-opengl \
#     libglu1-mesa-dev \
#     freeglut3-dev \
#     mesa-common-dev \
#     libignition-common-dev || true \
#     && rm -rf /var/lib/apt/lists/*


RUN git clone --depth 1 -b v22.11 https://github.com/PixarAnimationStudios/USD.git
RUN python3 /USD/build_scripts/build_usd.py --build-variant release --no-tests --no-examples --no-tutorials --no-docs --no-python /usr/local/USD

ENV PATH="/usr/local/USD/bin:$PATH" 
ENV LD_LIBRARY_PATH="/usr/local/USD/lib:$LD_LIBRARY_PATH"
ENV CMAKE_PREFIX_PATH="/usr/local/USD:$CMAKE_PREFIX_PATH"

RUN git clone https://github.com/gazebosim/gz-usd
# RUN rm /gz-usd/src/sdf_parser/Geometry.cc
# COPY /sdf_parser/Geometry.cc /gz-usd/src/sdf_parser/
RUN cd /gz-usd && cmake -B build && cd build && make -j4

WORKDIR /
