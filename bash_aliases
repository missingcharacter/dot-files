#!/usr/bin/env bash
# macOS and Ubuntu compatible aliases and functions
# ricdros' custom aliases
#alias grep='rg'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
#alias cat='bat'
#alias ls='exa'
#alias find='fd'
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
alias vim='nvim'
alias brewupgrade='brew update && brew upgrade && echo "You may want to run brew cleanup -n or just brew cleanup, also if pyenv was upgraded you will need to reinstall python"'
alias cleanneovim='rm -rf ~/.local/share/nvim ~/.cache/nvim'

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

function clean-multipass() {
  for i in $(multipass list | grep -v Name | awk '{ print $1 }'); do
    msg_info "Cleaning up ${i}"
    multipass delete "${i}"
  done
  multipass purge
}

function asdf-all () {
  awk '{ print $1 }' ~/.tool-versions | grep -v '^#'
}

function asdf-all-versions () {
  for i in $(asdf plugin list); do
    echo "Plugin ${i} and versions are $(asdf list "${i}")"
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

function youtube-dl-best() {
  local YOUTUBE_URL="${1}"
  # Assumes `ffmpeg` and/or `avconv` are in your path
  # `brew install ffmpeg`
  youtube-dl \
    -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
    --merge-output-format mp4 "${YOUTUBE_URL}"
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

function gitgrepwithinfiles() {
  local LIMIT_WORD="${1}"
  local SPECIFIC_WORD="${2}"
  while IFS= read -r line; do
    echo "filename: ${line}"
    grep -i "${SPECIFIC_WORD}" "${line}"
  done < <(git grep -li "${LIMIT_WORD}")
}

# from https://gist.github.com/lonnen/3101795 {

function gitgrepblame() {
  # runs git grep on a pattern, and then uses git blame to who did it
  local PATTERN="${1}"
  # shellcheck disable=SC2162
  git grep -n "${PATTERN}" | while IFS=: read i j k; do git blame -L "${j}","${j}" "${i}" | cat; done
}

function gitegrepblame() {
  # small modification for git egrep bash
  local PATTERN="${1}"
  # shellcheck disable=SC2162,SC2034
  git grep -E -n "${PATTERN}" | while IFS=: read i j k; do git blame -L  "${j}","${j}" "${i}"| cat; done
}

# }

function gitdiscardbranch() {
  local BRANCH_TO_DISCARD="${1}"
  local DEFAULT_BRANCH
  DEFAULT_BRANCH="$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)"
  git checkout "${DEFAULT_BRANCH}"
  git branch -D "${BRANCH_TO_DISCARD}"
  git pull
  git remote prune origin
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
  local CERT_INFO ISSUER VALID_UNTIL SUBJECT SAN OPENSSL_BIN
  declare -a OPENSSL_BINS=()
  mapfile -t OPENSSL_BINS < <(type -a openssl | awk '{ print $3 }')
  OPENSSL_BIN="${OPENSSL_BINS[0]}"
  CERT_INFO="$(echo | "${OPENSSL_BIN}" s_client \
      -connect "${IP_OR_HOSTNAME}:${PORT}" 2>/dev/null | "${OPENSSL_BIN}" x509 \
      -noout -text -certopt 'no_header,no_version,no_serial,no_signame,no_pubkey,no_sigdump,no_aux')"
  ISSUER="$(grep 'Issuer:' <<<"${CERT_INFO}" | cut -d ' ' -f9-20)"
  VALID_UNTIL="$(grep 'Not After :' <<<"${CERT_INFO}" | xargs)"
  SUBJECT="$(grep 'Subject:' <<<"${CERT_INFO}" | xargs)"
  SAN="$(grep 'DNS:' <<<"${CERT_INFO}" | xargs)"

  printf "%s\n%s\n%s\n%s\n" "${ISSUER}" "${VALID_UNTIL}" "${SUBJECT}" "${SAN}"
}

function list-shellcheck-files() {
  pre-commit run shellcheck --all-files 2>&1 | grep "^In " | awk '{ print $2 }' | sort -u
}

function print-python-path() {
  python -c 'import sys;print(sys.path)'
}

function create-temp-dir() {
  local pattern="${1:-tmpdirnoname}"
  if [[ 'Linux' == "$(uname)" ]]; then
    mktemp -d "${pattern}.XXXXXX"
  else
    mktemp -dt "${pattern}"
  fi
}

function print-bundle-cert-info() {
  local bundle_path="${1}"
  local fname='cert_file_'
  local tmp_path="" pattern=""
  echo "Bundle path: ${bundle_path}"
  tmp_path="$(create-temp-dir 'cert-bundle')"
  echo "Created temporary directory: ${tmp_path}"
  pattern="${tmp_path}/${fname}"
  if [[ 'Linux' == "$(uname)" ]]; then
    csplit -sz -f "${pattern}" "${bundle_path}" '/\-*BEGIN CERTIFICATE\-*/' '{*}'
  else
    split -p "-+BEGIN CERTIFICATE-+" "${bundle_path}" "${pattern}"
  fi

  for cert in "${pattern}"*; do
    echo "Certificate: ${cert}"
    openssl x509 -noout -subject -enddate -in "${cert}"
  done
  rm -rf "${tmp_path}"
}

function pkg_update() {
  declare -a supported_pkgs=() pkgs=()
  supported_pkgs=(
    "system"
    "mas"
    "brew"
    "asdf"
    "nodejs"
    "gem"
    "pip3"
    "mackup"
  )
  pkgs=("${@}")
  while IFS= read -r line; do
    if [[ -n ${line} ]]; then
      if [[ "${line}" == 'all' ]]; then
        pkgs=("${supported_pkgs[@]}")
      fi
    fi
  done < <(printf '%s\n' "${pkgs[@]}")
  msg_info "Packages to update: ${pkgs[*]}"
  for pkg in "${pkgs[@]}"; do
    case "${pkg}" in
      system|mas|brew|asdf|nodejs|gem|pip3|mackup)
        pkg_update_"${pkg}"
        ;;
      *)
        msg_error "Package ${pkg} is not supported"
        ;;
    esac
  done
}

function pkg_update_system() {
  case "$(uname)" in
    Darwin)
      msg_info 'sudo softwareupdate -i -a;'
      sudo softwareupdate -i -a;
      ;;
    Linux)
      msg_info 'sudo nala upgrade;'
      sudo nala upgrade;

      msg_info 'sudo snap refresh --list && sudo snap refresh;'
      sudo snap refresh --list && sudo snap refresh;

      msg_info 'flatpak update -y;'
      flatpak update -y;
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
}

function pkg_update_mas() {
  case "$(uname)" in
    Darwin)
      msg_info 'mas upgrade;'
      mas upgrade;
      ;;
    *)
      msg_info "mas only works on macOS"
      ;;
  esac
}

function pkg_update_brew() {
  case "$(uname)" in
    Darwin)
      msg_info 'brew cu -y;'
      brew cu -y;
      ;;
    *)
      msg_info "'brew cu' only works on macOS"
      ;;
  esac

  msg_info 'brew update; brew upgrade; brew cleanup;'
  msg_info 'if brew update fails you can try brew update-reset'
  brew update; brew upgrade; brew cleanup;
}

function pkg_update_asdf() {
  msg_info 'cd ~/.asdf/plugins/python/pyenv/ && git pull && cd -'
  cd ~/.asdf/plugins/python/pyenv/ || return 1
  git pull
  cd - || return 1

  msg_info 'asdf update; asdf plugin-update --all'
  asdf update; asdf plugin-update --all
}

function pkg_update_nodejs() {
  msg_info 'npm install -g npm; npm update -g;'
  npm install -g npm; npm update -g;
}

function pkg_update_gem() {
  msg_info 'gem update --system; gem update;'
  gem update --system; gem update;
}

function pkg_update_pip3() {
  msg_info 'pip3 list --outdated --local --format=json | jq -r ".[] | \"\(.name)==\(.latest_version)\"" | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip3 install -U'
  pip3 list --outdated --local --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U;
}

function pkg_update_mackup() {
  local folder=''
  case "$(uname)" in
    Darwin)
      folder='MacOS'
      ;;
    Linux)
      folder='PopOS'
      ;;
    *)
      msg_fatal "Operating System $(uname) is not supported"
      ;;
  esac

  msg_info 'hash -r'
  hash -r

  msg_info "mackup backup; folder is ${folder}"
  mackup backup;
  rclone sync -v --password-command "keyring get dot-files RCLONE_CONFIG_PASS" ~/.dot-files-rclone/ dot-files:"${folder}";
  rclone sync -v --password-command "keyring get dot-files RCLONE_CONFIG_PASS" ~/.dot-files-rclone/ dot-files-dropbox:"${folder}";
}

function delete_line_before_after() {
  local base_word="${1}"
  local word="${2}"
  local lines_before="${3:-0}"
  local lines_after="${4:-0}"
  local IFS=$'\n\t'

  declare -A files_and_lines=()
  declare -a grep_args=('-n')
  declare -a sed_args=('-i')

  if [[ "${lines_before}" -gt 0 ]]; then
    grep_args+=("-B${lines_before}")
  fi

  if [[ "${lines_after}" -gt 0 ]]; then
    grep_args+=("-A${lines_after}")
  fi

  if [[ "$(uname)" == 'Darwin' ]]; then
    sed_args+=('')
  fi

  # I use `git grep` on purpose because if I do something dumb I can
  # always revert the changes with `git checkout -- .`
  for i in $(git grep "${grep_args[@]}" "${base_word}" | grep "${word}"); do
    file="$(echo "${i}" | rev | cut -d '-' -f3- | rev)"
    line="$(echo "${i}" | rev | cut -d '-' -f2 | rev)"
    files_and_lines["${file}"]+="${line}d;"
  done

  for file in "${!files_and_lines[@]}"; do
    echo "Deleting lines ${files_and_lines[${file}]} from ${file}"
    sed "${sed_args[@]}" "${files_and_lines[${file}]}" "${file}"
  done
}

function cleancontainers() {
  declare -a docker_cmds=()
  case "$(uname)" in
    Darwin)
      docker_cmds+=('docker')
      ;;
    Linux)
      docker_cmds+=('sudo' 'docker')
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
  "${docker_cmds[@]}" ps -qa -f status=exited | xargs "${docker_cmds[@]}" rm
  "${docker_cmds[@]}" images -qa -f dangling=true | xargs "${docker_cmds[@]}" rmi
}

function cleandockervolumes() {
  declare -a docker_cmds=()
  case "$(uname)" in
    Darwin)
      docker_cmds+=('docker')
      ;;
    Linux)
      docker_cmds+=('sudo' 'docker')
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
  "${docker_cmds[@]}" volume ls -f dangling=true -q | xargs "${docker_cmds[@]}" volume rm
}

function dockerip() {
  local container_name_or_id="${1}"
  declare -a docker_cmds=()
  case "$(uname)" in
    Darwin)
      docker_cmds+=('docker')
      ;;
    Linux)
      docker_cmds+=('sudo' 'docker')
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
  "${docker_cmds[@]}" inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${container_name_or_id}"
}


function base64encodestring() {
  local TEXT="${1}"
  declare -a base64_cmds=()
  case "$(uname)" in
    Darwin)
      base64_cmds+=('base64')
      ;;
    Linux)
      base64_cmds+=('base64' '-w' '0')
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
  "${base64_cmds[@]}" <<<"${TEXT}"
}

function base64decodestring() {
  local TEXT="${1}"
  declare -a base64_cmds=()
  case "$(uname)" in
    Darwin)
      base64_cmds+=('base64' '-D')
      ;;
    Linux)
      base64_cmds+=('base64' '-d' '-w' '0')
      ;;
    *)
      msg_error "Operating System $(uname) is not supported"
      ;;
  esac
  "${base64_cmds[@]}" <<<"${TEXT}"
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
