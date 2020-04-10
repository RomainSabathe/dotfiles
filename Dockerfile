FROM ubuntu:16.04
MAINTAINER Romain Sabathe <RSabathe@gmail.com>

ENV HOME='/root'

# Essentials
RUN apt-get update && \
    # Adding repositories (neovim, python3.6, vim 8)
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
     xclip \
     # Requirements for coc
     nodejs \
     npm \
     # Other tools and requirements for linters, autocompleters etc.
     htop \
     iotop \
     iftop \
     bash \
     ctags \
     shellcheck \
     netcat \
     ack-grep \
     silversearcher-ag \
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
     pandoc \
     # Other librairies to work with machine learning and computer vision
     # Plus a few handy python tools
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
RUN git clone --recursive \
        https://github.com/pyenv/pyenv.git /home/app/.pyenv && \
    cd /home/app/.pyenv && \
    cd /root
ENV PATH="/home/app/.pyenv/bin:${PATH}"
ENV PYENV_ROOT="/home/app/.pyenv"
RUN eval "$(pyenv init -)" && \
    pyenv install 3.7.4 && \
    pyenv global 3.7.4
ENV PATH="/home/app/.pyenv/shims:${PATH}"

# Other tools and requirements for linters, autocompleters etc.
RUN  pip install --no-cache-dir \
      neovim \
      jedi \
      flake8 \
      flake8-docstrings \
      flake8-isort \
      pylint \
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
      pylint \
      isort \
      autopep8 \
      pep8-naming \
      black \
      pyment \
      pynvim \
     # Other librairies to work with machine learning and computer vision
     # Plus a few handy python tools
      numpy \
      pandas \
      jupyter \
      ipython \
      ipdb \
      dvc

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

# Installing Git LFS
RUN curl -LJ https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-linux-amd64-v2.10.0.tar.gz \
    --create-dirs \
    -o /tmp/git_lfs.tar.gz && \
    mkdir /tmp/git_lfs/ && \
    tar -C /tmp/git_lfs/ -xvf /tmp/git_lfs.tar.gz && \
    sh -c /tmp/git_lfs/install.sh && \
    rm -r /tmp/git_lfs/ && \
    rm /tmp/git_lfs.tar.gz

# Updating node (to use with coc).
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh)" && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    echo 'export NVM_DIR=$HOME/.nvm' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc  && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc && \
    nvm install --lts && nvm use --lts

# Installing fonts
COPY .fonts $HOME/.fonts
RUN fc-cache -f -v

# Placing the dot files
COPY .config $HOME/.config
COPY .tmux.conf $HOME/.tmux.conf

# Installing the plugins he plugins
RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvim -i NONE -c PlugInstall -c quitall && \
    nvim -i NONE -c "CocInstall coc-python" -c "sleep 5" -c quitall
    
# Configuring git to commit directly from the container
ARG USER_EMAIL
RUN git config --global user.name "Romain Sabathe" && \
    git config --global user.email $USER_EMAIL && \
    git config --global push.default simple

ENV TERM=xterm-256color
WORKDIR $HOME
ENTRYPOINT ["/bin/zsh"]
