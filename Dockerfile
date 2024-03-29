FROM bspwm-docker

USER root

RUN apt update && \
    apt install -y curl \
    gpg \
    coreutils \
    tree \
    nano \
    net-tools \
    locate \
    bsdmainutils

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt update && \
    apt install -y apt-transport-https code

# RUN useradd -m andrei
ENV USER andrei
WORKDIR /home/andrei/

RUN apt update \
    && apt install -y libnotify4 \
    libnss3 \
    libxkbfile1 \
    libgconf-2-4 \
    libsecret-1-0 \
    libgtk2.0-0 \
    libxss1 \
    libasound2 \
    libcanberra-gtk-module \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    ubuntu-mate-icon-themes \
    ubuntu-mate-themes

RUN apt update && \
    apt install -y git \
    gcc-8 \
    g++-8

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50 && \
    update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-8 50 && \
    update-alternatives --set g++ /usr/bin/g++-8 && \
    update-alternatives --set gcc /usr/bin/gcc-8 && \
    update-alternatives --set cpp-bin /usr/bin/cpp-8 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/g++-8 50

RUN apt update && \
    apt install -y wget && \ 
    wget https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init -O rustup-init && \
    chmod +x rustup-init

RUN echo 'include "/usr/share/themes/Ambiant-MATE/gtk-2.0/gtkrc"' > /home/andrei/.gtkrc-2.0

RUN echo "root:root" | chpasswd

RUN apt install -y libx11-xcb-dev \
    pkg-config

RUN chown andrei:andrei /home/andrei/.config

USER andrei

RUN ./rustup-init -y

COPY .bashrc .bashrc

RUN /home/andrei/.cargo/bin/rustup component add rust-analysis --toolchain stable-x86_64-unknown-linux-gnu && \
    /home/andrei/.cargo/bin/rustup component add rust-src --toolchain stable-x86_64-unknown-linux-gnu && \
    /home/andrei/.cargo/bin/rustup component add rls --toolchain stable-x86_64-unknown-linux-gnu

CMD ["/usr/bin/supervisord"]