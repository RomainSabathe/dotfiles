FROM ubuntu:18.04
MAINTAINER Romain Sabathe <RSabathe@gmail.com>

ENV HOME='/root'

# = Installing dependencies for Emacs & Doom =
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    curl && \
    add-apt-repository ppa:kelleyk/emacs && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        tar \
        clang

# Installing ripgrep
ENV RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb"
ENV FDFIND_URL="https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-musl_7.4.0_amd64.deb"
RUN curl -L $RIPGREP_URL -o /tmp/ripgrep.deb && \
    dpkg -i /tmp/ripgrep.deb && \
    curl -L $FDFIND_URL -o /tmp/fdfind.deb && \
    dpkg -i /tmp/fdfind.deb

# Installing Emacs
RUN apt-get install -y --no-install-recommends \
        emacs26

# Enable doom-auto-accept feature. Disable prompts during installation.
ENV YES="True"

ENV DOOM_URL="https://github.com/hlissner/doom-emacs"
RUN git clone $DOOM_URL $HOME/.emacs.d && \
    $HOME/.emacs.d/bin/doom install

# Configuring git to commit directly from the container
ARG USER_EMAIL
RUN git config --global user.name "Romain Sabathe" && \
    git config --global user.email $USER_EMAIL

WORKDIR $HOME
CMD /usr/bin/emacs
