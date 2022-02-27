# Manually created by rrosales

export EDITOR=vim
# git can now ask for gpg key passphrase
export GPG_TTY=$(tty)

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# https://asdf-vm.com/guide/getting-started.html#_3-install-asdf
. ${HOME}/.asdf/asdf.sh
. ${HOME}/.asdf/completions/asdf.bash
# Hook direnv into your shell.
eval "$(asdf exec direnv hook bash)"
# A shortcut for asdf managed direnv.
direnv() { asdf exec direnv "$@"; }

# Change Pinta Language back to english
#export LANG=en_GB
#export LANG=en_US.UTF-8

# Go specific env vars
export GOPATH="${HOME}/src/gopath"
export GOROOT="$(asdf where golang)/go"

# Java specific env vars
export JDK_HOME="$(asdf where java)"
export JAVA_HOME="$(asdf where java)/jre"

# Verbose terraform stderr
# export TF_LOG="TRACE"

# Custom CA Bundle
# export CURL_CA_BUNDLE=/path/to/cert.pem

# github's hub as an alias for git
#eval "$(hub alias -s)"

# bash completion section
#complete -C aws_completer aws
#complete -C /usr/local/bin/vault vault
#complete -C /usr/local/bin/nomad nomad
#complete -C /usr/local/bin/terraform terraform
#source <(kubectl completion bash)

# Sourcing Operating System specific bash_profile settings
if [ -f ~/.bash_os_profile ]; then
    . ~/.bash_os_profile
fi

# https://ohmyposh.dev/
# load oh-my-posh prompt
eval "$(oh-my-posh --init --shell bash --config ${HOME}/.ohmyposh.json)"

# opam configuration
test -r "${HOME}/.opam/opam-init/init.sh" && . "${HOME}/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true

# added by travis gem
[ ! -s ${HOME}/.travis/travis.sh ] || source ${HOME}/.travis/travis.sh
