# macOS and Ubuntu compatible aliases and functions
# ricdros' custom aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tmuxs='tmux source-file ~/.tmux.conf'
alias tmuxn='echo "Name the tmux session: "; read SESSION; tmux new -s ${SESSION}'
alias gitpushchange='git remote set-url --push origin'
alias gitcdroot='cd $(git rev-parse --show-toplevel)'
alias lowercaseuuid="uuidgen | tr -ds '-' '' | tr '[:upper:]' '[:lower:]'"
alias cssh='tmux-cssh -uc'
alias gitpushchange='git remote set-url --push origin'
alias gitcdroot='cd $(git rev-parse --show-toplevel)'
alias findterragruntcache='find . -type d -name ".terragrunt-cache"'
alias findterraformcache='find . -type d -name ".terraform"'
alias clearterragruntcache='find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;'
alias clearterraformcache='find . -type d -name ".terraform" -prune -exec rm -rf {} \;'
alias kdump='kubectl get all --all-namespaces'

function msg_info () {
  local GREEN='\033[0;32m'
  local NC='\033[0m' # No Color
  printf "${GREEN}${@}${NC}\n"
}

function msg_warn () {
  local YELLOW='\033[0;33m'
  local NC='\033[0m' # No Color
  printf "${YELLOW}${@}${NC}\n"
}

function msg_fatal () {
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color
  printf "${RED}${@}${NC}\n"
}

function to_lower() {
  echo "${1}" | tr '[:upper:]' '[:lower:]'
}

function to_upper() {
  echo "${1}" | tr '[:lower:]' '[:upper:]'
}

function gitconfig() {
  local CONFIG_TYPE="${1}"
  local EMAIL="$(keyring get git "${CONFIG_TYPE}_EMAIL")"
  local NAME="$(keyring get git "${CONFIG_TYPE}_NAME")"
  local GPG_SIGN="$(keyring get git "${CONFIG_TYPE}_GPG_SIGN")"
  git config user.name &> /dev/null && msg_warn 'user.name not set' || git config user.name "${NAME}" && msg_info 'user.name was set'
  git config user.email &> /dev/null && msg_warn 'user.email was not set' || git config user.email "${EMAIL}" && msg_info 'user.email was not set'
  git config commit.gpgsign &> /dev/null && msg_warn 'commit.gpgsign was not set' || git config commit.gpgsign "${GPG_SIGN}" && msg_info 'commit.gpgsign was set'
  git config tag.gpgsign &> /dev/null && msg_warn 'tag.gpgsign was not set' || git config tag.gpgsign "${GPG_SIGN}" && msg_info 'tag.gpgsign was set'
  [[ "${GPG_SIGN}" == 'true' ]] && git config user.signingkey "$(keyring get git "${CONFIG_TYPE}_GPG_KEY")" && msg_info 'user.signkey was set' || msg_warn 'user.signkey was not set'
}

function asdf-all () {
  awk '{ print $1 }' ~/.tool-versions
}

function httpval() {
  local URL=${1}
  curl --raw -LsD - -o /dev/null ${URL} \
  | grep -v -E '(Connection:|Date:|Server:|X-Frame-Options:|Keep-Alive:|Content-Length:|Content-Type:|Via:|Retry-After:|Content-Language:|Vary:|Content-Encoding:|Transfer-Encoding:|Set-Cookie:)'
}

function parentpid() {
  local PROCESS_ID=${1}
  ps -o ppid= -p ${PROCESS_ID} | xargs
}

function findcommands () {
  compgen -ac | grep ${1}
}

function sunglasses() {
	echo -en " (•_•)      \r"; sleep .5;
	echo -en " ( •_•)>⌐■-■\r"; sleep 1;
	echo -en " (⌐■_■)     \r"; sleep 1;
	echo -en "YEEEEAAAAAH!\n"; sleep 1;
}

function showmethecolours() {
  for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done
}

function cleancontainers() {
  docker ps -qa | xargs docker rm;
  docker images | grep '<none>' | awk '{ print $3 }' | xargs docker rmi
}

function virtualenv3() {
  python3 -m venv ${1}
}

# Sourcing Operating System Specific bash_aliases
if [ -f ~/.bash_os_aliases ]; then
    . ~/.bash_os_aliases
fi

# Sourcing personal bash_aliases
if [ -f ~/.bash_my_aliases ]; then
    . ~/.bash_my_aliases
fi

# Sourcing work only bash_aliases
if [ -f ~/.bash_work_aliases ]; then
    . ~/.bash_work_aliases
fi
