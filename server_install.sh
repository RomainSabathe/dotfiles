# Essentials
sudo apt-get update && apt-get install -y --no-install-recommends \
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
sudo add-apt-repository -y ppa:neovim-ppa/stable && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    add-apt-repository -y ppa:jonathonf/vim && \
    apt-get update

# Python
sudo apt-get install -y --no-install-recommends \
    python-setuptools \
    python3-setuptools \
	python-dev \
	python-pip \
    python3-pip \
    python3-dev \
    python3-tk  \
	python3.6 \
    python3.6-dev
    # Making sure python3.6 is called when invoking python 3
    # And python 2.7 is invoked otherwise.
    ln -s -f $(which python3.6) $(which python3) && \
    ln -s -f $(which python2.7) $(which python) && \
    ln -s -f $(which pip2) $(which pip)
    #pip3 install --no-cache-dir --upgrade pip setuptools

# Other tools and requirements for linters, autocompleters etc.
sudo apt-get install -y \
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
      black

# Other librairies to work with machine learning and computer vision
# Plus a few handy python tools
sudo apt-get install -y \
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

### Downloading the dot files and placing them
##RUN git clone https://github.com/RomainSabathe/dotfiles_ocean.git /tmp/resources && \
#    #cp -r /tmp/resources/.config $HOME && \
#    #cp -r /tmp/resources/.tmux.conf $HOME

## Installing Vim Plug  and the plugins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
nvim -i NONE -c PlugInstall -c quitall

export TERM=xterm-256color
