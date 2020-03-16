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

function gettoken() {
  local TOKEN_TO_LOOKUP="${1}"
  local FILE_WITH_TOKENS="${2:-"${HOME}/.tokens"}"
  local SEPARATOR='='
  grep "^${TOKEN_TO_LOOKUP}" ${FILE_WITH_TOKENS} | cut -d ${SEPARATOR} -f2
}

function gitclone() {
  local REPO="${1}"
  local DEFAULT_DIR="${REPO##*/}"
  local DIR="${2:-"${DEFAULT_DIR%.*}"}"
  local CLONE_TYPE="${3}"
  local EMAIL="$(gettoken "${CLONE_TYPE}_GIT_EMAIL")"
  local NAME="$(gettoken "${CLONE_TYPE}_GIT_NAME")"
  local GPG_SIGN="$(gettoken "${CLONE_TYPE}_GIT_GPG_SIGN")"
  git clone -c user.email="${EMAIL}" -c user.name="${NAME}" -c commit.gpgsign="${GPG_SIGN}" "${REPO}" "${DIR}"
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
