# Essentials
sudo apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:neovim-ppa/stable && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:jonathonf/vim && \
    add-apt-repository -y ppa:twodopeshaggy/jarun && \
    apt-get update && \
    apt-get install -y \
     apt-utils \
     git \
     unzip \
     openssh-client \
     build-essential \
     cmake \
     libopenblas-dev \
     man-db \
     software-properties-common \
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
     xclip \
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
     nnn \
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
     zlib1g-dev


# Pyenv
git clone --recursive \
        https://github.com/pyenv/pyenv.git /home/app/.pyenv && \
    cd /home/app/.pyenv && \
    cd /root
export PATH="/home/app/.pyenv/bin:${PATH}"
export PYENV_ROOT="/home/app/.pyenv"
eval "$(pyenv init -)" && \
    pyenv install 3.6.9 && \
    pyenv global 3.6.9
export PATH="/home/app/.pyenv/shims:${PATH}"

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
    pip3 install --no-cache-dir --upgrade \
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
      pyment \
      pynvim \
      numpy \
      pandas \
      jupyter \
      ipython \
      ipdb \
      dvc

# Installing VTE (requirement for Termite)
git clone https://github.com/thestinger/vte-ng.git /tmp/vte && \
    echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH" && \
	cd /tmp/vte && \
    ./autogen.sh && \
	make && \
    make install

# Building Termite
git clone --recursive https://github.com/thestinger/termite.git /tmp/termite && \
    cd /tmp/termite && \
    make && \
    make install && \
    ldconfig && \
    mkdir -p /lib/terminfo/x && \
    ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite && \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

# Installing oh-my-zsh
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    git config --global core.autocrlf input

# Installing the plugins he plugins
nvim -i NONE -c PlugInstall -c quitall
