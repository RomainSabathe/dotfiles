FROM ubuntu:16.04
MAINTAINER Romain Sabathe <RSabathe@gmail.com>

ENV HOME='/root'

# Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    unzip \
    openssh-client \
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
    gperf \ 
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    git


# Adding repositories (neovim, python3.6, vim 8)
RUN add-apt-repository -y ppa:neovim-ppa/stable && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:jonathonf/vim && \
    add-apt-repository -y ppa:twodopeshaggy/jarun && \
    apt-get update

# Pyenv
RUN git clone --recursive \
        https://github.com/pyenv/pyenv.git /home/app/.pyenv && \
    cd /home/app/.pyenv && \
    cd /root
ENV PATH="/home/app/.pyenv/bin:${PATH}"
ENV PYENV_ROOT="/home/app/.pyenv"
RUN eval "$(pyenv init -)" && \
    pyenv install 3.6.9 && \
    pyenv global 3.6.9
ENV PATH="/home/app/.pyenv/shims:${PATH}"

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
      feh \
      nnn && \
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
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    # Installing VimPlug
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    # Forcing git to pull data relative to Linux and not Windows
    # (Needed for Vundle & using my .nvim/init file)
    git config --global core.autocrlf input

# Installing fonts
COPY .fonts $HOME/.fonts
RUN fc-cache -f -v

# Placing the dot files
COPY .config $HOME/.config
COPY .tmux.conf $HOME/.tmux.conf

# Installing the plugins he plugins
RUN nvim -i NONE -c PlugInstall -c quitall
    
# Configuring git to commit directly from the container
ARG USER_EMAIL
RUN git config --global user.name "Romain Sabathe" && \
    git config --global user.email $USER_EMAIL

ENV TERM=xterm-256color
WORKDIR $HOME
CMD ["/bin/zsh"]
