#/bin/bash

# bash -c "$(curl -fsSL https://raw.github.com/samuelr/dot-files/master/.dotfiles/bootstrap-dotfiles.sh)"

# also zsh (with --disable-etcdir)
BREWS="ack autojump ctags git macvim python tmux tree wget"

# Debian/Ubuntu:
# build-essential - for GCC, GNU Make, etc.
# ruby-dev - for Vim Command-T

# also autojump (Ubuntu only)
DEB_PKGS="ack-grep build-essential curl exuberant-ctags git ruby-dev tmux tree vim-nox zsh"

die() {
    echo "Error: $1"
    exit 1
}

_homebrew() {
    # homebrew packages
    ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)
    brew install ${BREWS}

    # work around for OS X mis-configuration
    brew install --disable-etcdir zsh
}

_git() {
    # set up git repository
    cd ${HOME}
    mkdir -p src/github
    cd src/github
    git clone https://github.com/SamRozen/utils.git
    git clone https://github.com/SamRozen/dot-files.git
    cd ${HOME}
    ln -s ~/src/github/utils bin
    ln -s ~/src/github/dot-files/.dotfiles
    ln -s ~/.dotfiles/.aliases
    ln -s ~/.dotfiles/.gitconfig
}

_zsh() {
    # change default shell
    if [[ "$(uname -s)" == "Darwin" ]]; then
        chsh -s /usr/local/bin/zsh
    else
        chsh -s /bin/zsh
    fi
    curl -L http://install.ohmyz.sh | sh
    mv ${HOME}/.zshrc ${HOME}/.zshrc.orig
    ln -s ~/.dotfiles/.zshrc
    # Cannot add submodule within oh-my-zsh submodule
    mkdir -p ${HOME}/.oh-my-zsh/custom/plugins
    cd ${HOME}/.oh-my-zsh/custom/plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
}

cwd=$(pwd)

[[ "$(uname -s)" == "Darwin" ]] && _homebrew
_git
_zsh

cd ${cwd}
