FROM floydhub/dl-docker:gpu

# Add openMVG binaries to path
ENV PATH $PATH:/opt/openMVG_Build/install/bin

# Get dependencies
RUN apt-get update -qq && apt-get install -y \
  # build-essential \
  # cmake \
  graphviz
  # git \
  # gcc-4.8 \
  # gcc-4.8-multilib \
  # libpng-dev \
  # libjpeg-dev \
  # libtiff-dev \
  # libxxf86vm1 \
  # libxxf86vm-dev \
  # libxi-dev \
  # libxrandr-dev \
  # python-dev \
  # python-pip

# Clone the openvMVG repo
ADD . /opt/openMVG

ENV PATH=/usr/local/cuda-8.0/include:$PATH

RUN sed -ie 's/cuda_runtime.h/\/usr\/local\/cuda-8.0\/include\/cuda_runtime.h/g' /usr/local/include/opencv2/core/cuda_stream_accessor.hpp

# Build
RUN mkdir /opt/openMVG_Build && cd /opt/openMVG_Build && cmake -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX="/opt/openMVG_Build/install" -DOpenMVG_BUILD_TESTS=OFF \
  -DOpenMVG_BUILD_EXAMPLES=OFF . ../openMVG/src/ && make

RUN cd /opt/openMVG_Build && make test

# Add Canon 1200D
RUN sed -i '/^Canon EOS 1100D;22.2/aCanon EOS 1200D;22.2' /opt/openMVG/src/openMVG/exif/sensor_width_database/sensor_width_camera_database.txt
