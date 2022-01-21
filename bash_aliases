#!/usr/bin/env bash
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
alias gitamendresetauthor='git commit --amend --reset-author --no-edit'
alias gitcdroot='cd $(git rev-parse --show-toplevel)'
alias gitpushchange='git remote set-url --push origin'
alias lowercaseuuid="uuidgen | tr -ds '-' '' | tr '[:upper:]' '[:lower:]'"
alias lowercaseuuidwithdashes="uuidgen | tr '[:upper:]' '[:lower:]'"
alias cssh='tmux-cssh -uc'
alias findterragruntcache='find . -type d -name ".terragrunt-cache"'
alias findterraformcache='find . -type d -name ".terraform"'
alias clearterragruntcache='find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;'
alias clearterraformcache='find . -type d -name ".terraform" -prune -exec rm -rf {} \;'
alias clearawscreds='truncate -s 0 ~/.aws/credentials'
alias getkubeconfig="pulumi stack output -j k8s-controllers | jq -r '.[].iam_kubeconfig'"
alias kdump='kubectl get all --all-namespaces'
alias kips='kubectl get nodes -o jsonpath={.items[*].status.addresses[?\(@.type==\"InternalIP\"\)].address}'
# If you want to see where cpu/memory is being used at
alias kpodscpu='kubectl top pods --containers --sort-by=cpu'

export ANSI_NO_COLOR=$'\033[0m'
function msg_info () {
  local GREEN=$'\033[0;32m'
  printf "%s\n" "${GREEN}${*}${ANSI_NO_COLOR}"
}

function msg_warn () {
  local YELLOW=$'\033[0;33m'
  printf "%s\n" "${YELLOW}${*}${ANSI_NO_COLOR}"
}

function msg_error () {
  local LRED=$'\033[01;31m'
  printf "%s\n" "${LRED}${*}${ANSI_NO_COLOR}"
}

function msg_fatal () {
  local RED=$'\033[0;31m'
  printf "%s\n" "${RED}${*}${ANSI_NO_COLOR}"
}

function to_lower() {
  echo "${1}" | tr '[:upper:]' '[:lower:]'
}

function to_upper() {
  echo "${1}" | tr '[:lower:]' '[:upper:]'
}

function setgitconfig() {
  local FIELD
  local VALUE
  FIELD="${1}"
  VALUE="${2}"
  if git config "${FIELD}" &> /dev/null; then
    msg_warn "${FIELD} was not set"
  else
    git config "${FIELD}" "${VALUE}"
    msg_info "${FIELD} was set"
  fi
}

function gitconfig() {
  local CONFIG_TYPE
  local GPG_SIGN
  CONFIG_TYPE="${1}"
  GPG_SIGN="$(keyring get git "${CONFIG_TYPE}_GPG_SIGN")"
  setgitconfig 'user.name' "$(keyring get git "${CONFIG_TYPE}_NAME")"
  setgitconfig 'user.email' "$(keyring get git "${CONFIG_TYPE}_EMAIL")"
  setgitconfig 'commit.gpgsign' "${GPG_SIGN}"
  setgitconfig 'tag.gpgsign' "${GPG_SIGN}"
  if [[ "${GPG_SIGN}" == 'true' ]]; then
    setgitconfig 'user.signingkey' "$(keyring get git "${CONFIG_TYPE}_GPG_KEY")"
  fi
}

function asdf-all () {
  awk '{ print $1 }' ~/.tool-versions
}

function asdf-all-versions () {
  for i in $(asdf plugin list); do
    echo "Plugin ${i} and versions are $(asdf list ${i})"
  done
}

function httpval() {
  local URL=${1}
  curl --raw -LsD - -o /dev/null "${URL}" \
  | grep -v -E '(Connection:|Date:|Server:|X-Frame-Options:|Keep-Alive:|Content-Length:|Content-Type:|Via:|Retry-After:|Content-Language:|Vary:|Content-Encoding:|Transfer-Encoding:|Set-Cookie:)'
}

function parentpid() {
  local PROCESS_ID=${1}
  ps -o ppid= -p "${PROCESS_ID}" | xargs
}

function findcommands () {
  compgen -ac | grep "${1}"
}

function sunglasses() {
	echo -en " (•_•)      \r"; sleep .5;
	echo -en " ( •_•)>⌐■-■\r"; sleep 1;
	echo -en " (⌐■_■)     \r"; sleep 1;
	echo -en "YEEEEAAAAAH!\n"; sleep 1;
}

function showmethecolours() {
  for i in {0..255}; do printf "\x1b[38;5;%smcolour%s\x1b[0m\n" "${i}" "${i}"; done
}

function virtualenv3() {
  python3 -m venv "${1}"
}

function gitgrepdiff() {
  local STRING="${1}"
  local DEFAULT_BRANCH="${2:-$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')}"
  local BRANCH="${3:-$(git branch --show-current)}"
  # see https://git-scm.com/docs/git-diff
  # --diff-filter=[(A|C|D|M|R|T|U|X|B)…[*]]
  local DIFF_FILTERS=${4:-A}
  # shellcheck disable=SC2046
  git grep -l "${STRING}" $(git diff "${DEFAULT_BRANCH}"..."${BRANCH}" --name-status --diff-filter="${DIFF_FILTERS}" | awk '{ print $2 }')
}

function argodiff() {
  local APP_TO_CHECK
  APP_TO_CHECK="${1}"
  APP="$(kubectl get applications -n argocd "${APP_TO_CHECK}" -o yaml)"
  diff <(echo "$APP" | yq e '.status.history[-2]' -) <(echo "$APP" | yq e '.status.history[-1]' -)
}

function kube-run-in-node() {
  local NODE_NAME="${1}"
  local OVERRIDES="{\"spec\":{\"nodeName\":\"${NODE_NAME}\"}}"
  kubectl run --rm -i --tty \
    ricdros-test --image=quay.io/giantswarm/debug --overrides="${OVERRIDES}" -- bash
}

function check-ssl() {
  local IP_OR_HOSTNAME="${1}"
  local PORT="${2:-443}"
  local CERT_INFO ISSUER VALID_UNTIL SUBJECT SAN
  CERT_INFO="$(echo | openssl s_client -connect ${IP_OR_HOSTNAME}:${PORT} 2>/dev/null | openssl x509 -noout -text -certopt 'no_header,no_version,no_serial,no_signame,no_pubkey,no_sigdump,no_aux')"
  ISSUER="$(grep 'Issuer:' <<<${CERT_INFO} | cut -d ' ' -f9-20)"
  VALID_UNTIL="$(grep 'Not After :' <<<${CERT_INFO} | xargs)"
  SUBJECT="$(grep 'Subject:' <<<${CERT_INFO} | xargs)"
  SAN="$(grep 'DNS:' <<<${CERT_INFO} | xargs)"

  printf "${ISSUER}\n${VALID_UNTIL}\n${SUBJECT}\n${SAN}\n"
}

# Sourcing Operating System Specific bash_aliases
if [ -f ~/.bash_os_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_os_aliases
fi

# Sourcing personal bash_aliases
if [ -f ~/.bash_my_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_my_aliases
fi

# Sourcing work only bash_aliases
if [ -f ~/.bash_work_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_work_aliases
fi
