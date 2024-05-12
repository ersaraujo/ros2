FROM ubuntu:22.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
    curl \
    cmake \
    gnupg2 \
    pkg-config \
    lsb-release \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN sh -c 'echo "deb [arch=amd64,arm64,armhf] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN curl -fsSL https://packages.osrfoundation.org/gazebo.gpg | gpg --dearmor -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
         http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
         | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null


COPY dependencies.txt /tmp/dependencies.txt

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y $(cat /tmp/dependencies.txt) && \
    rm -rf /var/lib/apt/lists/* /tmp/dependencies.txt

RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

CMD ["/bin/bash"]