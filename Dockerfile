FROM ubuntu:16.04
MAINTAINER Romain Sabathe <RSabathe@gmail.com>

ENV HOME='/root'

# Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    curl \
    unzip \
    openssh-client \
    wget \
    build-essential \
    cmake \
    libopenblas-dev \
    man-db \
    software-properties-common \
    # Requirements to install termite
    g++ \
    libgtk-3-dev \
    gtk-doc-tools gnutls-bin \
    valac \
    intltool \
    libpcre2-dev \
    libglib3.0-cil-dev \
    libgnutls28-dev \
    libgirepository1.0-dev \
    libxml2-utils \
    gperf

# Adding repositories (neovim, python3.6, vim 8)
RUN add-apt-repository -y ppa:neovim-ppa/stable && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:jonathonf/vim && \
    apt-get update

# Python
RUN apt-get install -y --no-install-recommends \
    python-setuptools \
    python3-setuptools \
	python-dev \
	python-pip \
    python3-pip \
    python3-dev \
    python3-tk  \
	python3.6 \
    python3.6-dev && \
    # Making sure python3.6 is called when invoking python 3
    # And python 2.7 is invoked otherwise.
    ln -s -f $(which python3.6) $(which python3) && \
    ln -s -f $(which python2.7) $(which python) && \
    ln -s -f $(which pip2) $(which pip)
    #pip3 install --no-cache-dir --upgrade pip setuptools

# Other tools and requirements for linters, autocompleters etc.
RUN apt-get install -y \
      htop \
      iotop \
      iftop \
      bash \
      ctags \
      shellcheck \
      netcat \
      ack-grep \
      unzip \
      exuberant-ctags \
      vim \
      neovim \
      tmux \
      zsh \
      i3 \
      ranger \
      vifm \
      feh && \
    pip install --no-cache-dir \
      neovim \
      jedi \
      flake8 \
      flake8-docstrings \
      flake8-isort \
      isort \
      autopep8 \
      pyment \
      pep8-naming && \
    pip3 install --no-cache-dir \
      neovim \
      jedi \
      flake8 \
      flake8-docstrings \
      flake8-isort \
      flake8-bugbear \
      isort \
      autopep8 \
      pep8-naming \
      black \
      pyment

# Other librairies to work with machine learning and computer vision
# Plus a few handy python tools
RUN apt-get install -y \
      libjpeg-dev \
      libjpeg8-dev \
      libtiff5-dev \
      libjasper-dev \
      libpng12-dev \
      libavcodec-dev \
      libavformat-dev \
      libswscale-dev \
      libv4l-dev \
      libgtk2.0-dev \
      liblapacke-dev \
      checkinstall \
      zlib1g-dev && \
    pip3 --no-cache-dir install \
      numpy \
      pandas \
      jupyter \
      ipython \
      ipdb

# Installing VTE (requirement for Termite)
RUN git clone https://github.com/thestinger/vte-ng.git /tmp/vte && \
    echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH" && \
	cd /tmp/vte && \
    ./autogen.sh && \
	make && \
    make install

# Building Termite
RUN git clone --recursive https://github.com/thestinger/termite.git /tmp/termite && \
    cd /tmp/termite && \
    make && \
    make install && \
    ldconfig && \
    mkdir -p /lib/terminfo/x && \
    ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite && \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

# Installing oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Downloading the dot files and placing them
RUN git clone https://github.com/RomainSabathe/dotfiles_ocean.git /tmp/resources && \
    cp -r /tmp/resources/.config $HOME && \
    cp -r /tmp/resources/.tmux.conf $HOME
    
# Installing Vim Plug  and the plugins
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    nvim -i NONE -c PlugInstall -c quitall

# Installing fonts
RUN mkdir $HOME/.fonts && \
    cp -r /tmp/resources/.fonts $HOME/.fonts && \
    fc-cache -f -v
    
# The python apt_pkg package doesn't play well with Python 3.6
RUN apt-get install -y python-apt python3-apt && \
    ln -s /usr/lib/python3/dist-packages/apt_pkg.cpython-{35m,36m}-x86_64-linux-gnu.so \
    ln -s /usr/lib/python3/dist-packages/apt_inst.cpython-{35m,36m}-x86_64-linux-gnu.so


ENV TERM=
WORKDIR $HOME
CMD ["/bin/bash"]
