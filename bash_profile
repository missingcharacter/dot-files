# Manually created by rrosales

export EDITOR=vim
# git can now ask for gpg key passphrase
GPG_TTY=$(tty)
export GPG_TTY

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
if [ -f "${HOME}"/.bash_aliases ]; then
  . "${HOME}"/.bash_aliases
fi

# https://asdf-vm.com/guide/getting-started.html#_3-install-asdf
. "${HOME}"/.asdf/asdf.sh
. "${HOME}"/.asdf/completions/asdf.bash
# Hook direnv into your shell.
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/bashrc"

# Change Pinta Language back to english
#export LANG=en_GB
#export LANG=en_US.UTF-8

# Go specific env vars
GOPATH="${HOME}/src/gopath"
GOROOT="$(asdf where golang)/go"
export GOPATH GOROOT

# Java specific env vars
JDK_HOME="$(asdf where java)"
JAVA_HOME="$(asdf where java)/jre"
export JDK_HOME JAVA_HOME

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
if [ -f "${HOME}"/.bash_os_profile ]; then
    . "${HOME}"/.bash_os_profile
fi

# Sourcing Work specific bash_profile settings
if [ -f "${HOME}"/.bash_work_profile ]; then
    . "${HOME}"/.bash_work_profile
fi

# https://ohmyposh.dev/
# load oh-my-posh prompt
#eval "$(oh-my-posh --init --shell bash --config "$(fd --type f -F -- 'dracula.omp.json' "$(brew --cellar)/oh-my-posh")")"
eval "$(oh-my-posh --init --shell bash --config "${HOME}"/.ohmyposh.json)"

# opam configuration
test -r "${HOME}/.opam/opam-init/init.sh" && . "${HOME}/.opam/opam-init/init.sh" &> /dev/null || true
