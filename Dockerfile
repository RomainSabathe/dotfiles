FROM ubuntu:20.04
MAINTAINER Romain Sabathe <RSabathe@gmail.com>

ENV HOME='/root'

# Prevents software install to stall because of user input
ARG DEBIAN_FRONTEND=noninteractive
# Essentials
RUN apt-get update && \
    # Adding repositories (neovim, python3.6, vim 8)
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    #add-apt-repository -y ppa:jonathonf/vim && \
    add-apt-repository ppa:linuxuprising/libpng12 && \
    add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && \
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
     file \
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
     jq \
     # Latex,...
     texlive-full \
     inotify-tools \
     # And requirements for Tectonic
     libfontconfig1-dev \
     libgraphite2-dev \
     libharfbuzz-dev \
     libicu-dev \
     # Other librairies to work with machine learning and computer vision
     # Plus a few handy python tools
     libjpeg-dev \
     libjpeg8-dev \
     libtiff5-dev \
     libjasper-dev \
     libjasper1 \
     libpng12-0 \
     libavcodec-dev \
     libavformat-dev \
     libswscale-dev \
     libv4l-dev \
     libgtk2.0-dev \
     liblapacke-dev \
     checkinstall \
     zlib1g-dev \
     llvm-dev \
     libclang-dev \
     clang \
     openssl \
     pkg-config \
     libssl-dev \
     xz-utils \
     # Image/Video tools
     ffmpeg \
     vlc \
     mplayer \
     mpv \
     gimp \
     geeqie \
     # Other
     firefox \
     evince \
     zathura

# Installing Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rust.sh && \
    sh /tmp/rust.sh -y && \
    export PATH="$PATH:$HOME/.cargo/bin" && \
    echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> .bashrc && \
    cargo install exa \
                  ripgrep \
                  dirscan \
                  rip \
                  tectonic \
                  starship \
                  bat \
                  tokei \
                  fd \
                  procs \
                  imager \
                  todor \
                  xsv \
                  amp \
                  dust \
                  gitui \
                  clog-cli \
                  git-delta \
                  git-journal && \
    rm /tmp/rust.sh

# Pyenv
RUN git clone --recursive \
        https://github.com/pyenv/pyenv.git /home/app/.pyenv && \
    cd /home/app/.pyenv && \
    cd /root
ENV PATH="/home/app/.pyenv/bin:${PATH}"
ENV PYENV_ROOT="/home/app/.pyenv"
RUN eval "$(pyenv init -)" && \
    pyenv install 3.9.0 && \
    pyenv global 3.9.0
ENV PATH="/home/app/.pyenv/shims:${PATH}"

# Other tools and requirements for linters, autocompleters etc.
RUN  pip install --no-cache-dir \
      jedi \
      flake8 \
      flake8-docstrings \
      flake8-isort \
      pylint \
      isort \
      autopep8 \
      pyment \
      pynvim \
      pep8-naming && \
    pip3 install --no-cache-dir --upgrade \
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
      mypy \
      prospector \
      pyment \
      pynvim \
     # Other librairies to work with machine learning and computer vision
     # Plus a few handy python tools
      numpy \
      pandas \
      jupyter \
      ipython \
      matplotlib \
      seaborn \
      scikit-learn \
      ipdb \
      click \
      pytest \
      Pillow \
      imageio \
      dvc

# # Installing VTE (requirement for Termite)
# RUN git clone https://github.com/thestinger/vte-ng.git /tmp/vte && \
#     echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH" && \
# 	cd /tmp/vte && \
#     ./autogen.sh && \
# 	make && \
#     make install
# 
# # Building Termite
# RUN git clone --recursive https://github.com/thestinger/termite.git /tmp/termite && \
#     cd /tmp/termite && \
#     make && \
#     make install && \
#     ldconfig && \
#     mkdir -p /lib/terminfo/x && \
#     ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite && \
#     update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

# Installing oh-my-zsh
#RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
        ## Installing VimPlug
        #sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        #   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' && \
    # Forcing git to pull data relative to Linux and not Windows
    # (Needed for Vundle & using my .nvim/init file)
RUN git config --global core.autocrlf input

# Updating node & yarn (to use with coc).
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh)" && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    echo 'export NVM_DIR=$HOME/.nvm' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc  && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc && \
    echo 'alias latexindent.pl="/usr/bin/latexindent"' >> ~/.zshrc && \
    nvm install --lts && nvm use --lts && \
    npm install -g yarn

# Installing Git LFS
RUN curl -LJ https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-linux-amd64-v2.10.0.tar.gz \
    --create-dirs \
    -o /tmp/git_lfs.tar.gz && \
    mkdir /tmp/git_lfs/ && \
    tar -C /tmp/git_lfs/ -xvf /tmp/git_lfs.tar.gz && \
    sh -c /tmp/git_lfs/install.sh && \
    rm -r /tmp/git_lfs/ && \
    rm /tmp/git_lfs.tar.gz

# Installing awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" &&\
    unzip /tmp/awscliv2.zip -d /tmp && \
    tmp/aws/install && \
    rm -r /tmp/aws /tmp/awscliv2.zip  

# Installing prettier
RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    npm install prettier --save-dev --save-exact && \
    npm install pretty-quick husky --save-dev 

# Installing fonts
COPY .fonts $HOME/.fonts
RUN fc-cache -f -v

# Installing Antigen
RUN mkdir -p $HOME/.config/zsh && \
    curl -L git.io/antigen > $HOME/.config/zsh/antigen.zsh && \
    echo 'source $HOME/.config/zsh/antigen.zsh' >> $HOME/.zshrc && \
    echo 'antigen init ~/.config/zsh/antigenrc' >> $HOME/.zshrc
#
# It's important that the lines are in this order.
COPY .config/zsh/antigenrc $HOME/.config/zsh/antigenrc
RUN echo "export NVM_DIR='$HOME/.nvm'" >> $HOME/.zshrc && \
    echo "export PATH='$HOME/.cargo/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH'" >> $HOME/.zshrc && \
    echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> $HOME/.zshrc && \
    # Making zsh the default shell
    chsh -s /bin/zsh && su - $USER && \
    # Forcing the installation of antigen bundles.
    /bin/zsh -c "source $HOME/.config/zsh/antigen.zsh && \
                 antigen init $HOME/.config/zsh/antigenrc"

COPY .config/nvim $HOME/.config/nvim
# Installing the plugins
RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    curl -sL install-node.now.sh/lts | bash -s -- --force && \
    #git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim && \
    # Installing dein.vim
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && \
    sh ./installer.sh ~/.cache/dein && \
    # Installing yarn
    curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" && \
    #nvim -c PluginInstall -c quitall
    # Installing fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all && \
    nvim -c "call dein#install()" -c "UpdateRemotePlugins" -c quitall && \
    nvim +'CocInstall -sync coc-pyright coc-git coc-vimtex' +qall && \
    echo "let g:coc_node_path = '/usr/local/bin/node'" >> $HOME/.config/nvim/init.vim
    
# Configuring git to commit directly from the container
ARG USER_EMAIL
RUN git config --global user.name "Romain Sabathe" && \
    git config --global user.email $USER_EMAIL && \
    git config --global push.default simple

# Placing the dot files
COPY .vifm $HOME/.vifm
COPY .tmux.conf $HOME/.tmux.conf
COPY .config $HOME/.config
RUN cat $HOME/.config/zsh/.zshrc_extra >> ~/.zshrc
ENV TERM=xterm-256color
WORKDIR $HOME
ENTRYPOINT ["/bin/zsh"]
