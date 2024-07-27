#FROM ubuntu:22.04
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04
SHELL ["/bin/bash", "-c"]

# Timezone, Launguage設定
RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
     locales \
     software-properties-common tzdata \
  && locale-gen ja_JP ja_JP.UTF-8  \
  && update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 \
  && add-apt-repository universe

# Locale
ENV LANG ja_JP.UTF-8
ENV TZ=Asia/Tokyo

#package install
RUN apt update && apt upgrade -y\
    && DEBIAN_FRONTEND=noninteractive apt install -y curl vim git wget htop sudo\
    python3.10-dev python-is-python3 python3-pip \
    gnupg gnupg2 lsb-release nano build-essential automake autoconf libtool flex bison libboost-all-dev g++

#userをグループに追加
ARG UID=1000
ARG GID=1000
ARG USER_NAME=nishinolab
ARG GROUP_NAME=takahashi

#sudo パスワードを無効化
RUN groupadd -g ${GID} ${GROUP_NAME} && \
        useradd -m -s /bin/bash -u ${UID} -g ${GID} -G sudo ${USER_NAME} && \
        echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/${USER_NAME}

#ユーザーをrootからユーザーに変更
USER $USER_NAME

#PS1
RUN echo "PS1='\[\033[44;37m\]Docker\[\033[0m\]@\[\033[32m\]\u\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]\$ '" >> /home/${USER_NAME}/.bashrc

#installrobocupsoccer server
RUN mkdir rcss
COPY rcssserver-19.0.0 ./rcssserver-19.0.0
RUN cd rcssserver-19.0.0 ; sudo ./configure ; sudo make ; sudo make install

#install robocupsoccer monitor
COPY rcssmonitor-19.0.0 ./rcssmonitor-19.0.0
RUN sudo apt-get update ; sudo apt-get install -y clang qtcreator \
    libfontconfig1-dev libaudio-dev libxt-dev libglib2.0-dev libxi-dev libxrender-dev 
        
RUN git clone https://github.com/rcsoccersim/rcssmonitor.git &&\
    sudo apt-get update && sudo apt install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools qtcreator qtmultimedia5-dev libqt5multimediawidgets5 libqt5multimedia5-plugins &&\
    sudo apt-get install -y `apt-cache search 5-examples | grep qt | grep example | awk '{print $1 }' | xargs` `apt-cache search 5-doc | grep "^qt" | awk '{print $1}' | xargs` &&\
    cd rcssmonitor/ ; ./bootstrap ; ./configure ; make &&\
    cd rcssmonitor-19.0.0 &&\
    sudo ./configure ; sudo make ; sudo make install 

#tempに実行ファイル追加
COPY entry_point.sh /tmp/entry_point.sh
RUN sudo chmod +x /tmp/entry_point.sh ;\
    sudo chmod -R 777 /home/${USER_NAME}/rcss 
WORKDIR /home/${USER_NAME}/rcss
ENTRYPOINT ["/tmp/entry_point.sh"]
#setup.shで毎回source /opt/ros/humble/setup.bashしている
