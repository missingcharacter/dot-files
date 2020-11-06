#!/usr/bin/env bash
# Enable bash's unofficial strict mode
GITROOT=$(git rev-parse --show-toplevel)
. ${GITROOT}/lib/strict-mode
strictMode
. ${GITROOT}/lib/utils

THIS_SCRIPT=$(basename $0)
PADDING=$(printf %-${#THIS_SCRIPT}s " ")

function usage() {
    msg_info "Usage:"
    msg_info "${THIS_SCRIPT} -i <Optional, 'y' or 'n'>"
    echo
    msg_info "Sets up base macOS and Ubuntu system" >&2
    msg_info "-i avoids asking you every time if you want to install something or not" >&2
    exit 1
}

function check_dependencies() {
  # Ensure dependencies are present
  if [[ ! -x $(command -v git) ]]; then
      msg_fatal "[-] Dependencies unmet. Please verify that the following are installed and in the PATH: git" >&2
      exit 1
  fi
}

check_dependencies

UNAME_OUTPUT=$(uname -s)
case "${UNAME_OUTPUT}" in
    Linux*)
      if grep -i ubuntu /etc/os-release &> /dev/null; then
        MACHINE_OS='Ubuntu'
      else
        msg_fatal "Only Ubuntu is supported" >&2
        exit 1
      fi;;
    Darwin*)
      MACHINE_OS='MacOS';;
    *)
      msg_fatal "UNKNOWN OS: ${UNAME_OUTPUT}" >&2
      exit 1
esac

while getopts ":i:" opt; do
  case ${opt} in
    i)
      if [[ "$OPTARG" == "y" || "$OPTARG" == "n" ]]; then
        INSTALL_EVERYTHING=${OPTARG}
      else
        usage
      fi ;;
    \?)
      usage ;;
    :)
      usage ;;
  esac
done

# Installing basics
. ${GITROOT}/${MACHINE_OS}/base
is_asdf_installed "${INSTALL_EVERYTHING:-''}"

# Setting up mackup
MACKUP_CUSTOM_APPS_DIR="${HOME}/.mackup"
if [[ ! -d "${MACKUP_CUSTOM_APPS_DIR}" ]]; then
  msg_info "Creating ${MACKUP_CUSTOM_APPS_DIR} dir"
  mkdir "${MACKUP_CUSTOM_APPS_DIR}"
fi

MACKUP_MY_FILES_CFG="${MACKUP_CUSTOM_APPS_DIR}/my-files.cfg"
if [[ ! -L "${MACKUP_MY_FILES_CFG}" ]]; then
  echo "Force symbolic link source: ${GITROOT}/my-files.cfg target: ${MACKUP_MY_FILES_CFG}"
  ln -sf "${GITROOT}/my-files.cfg" "${MACKUP_MY_FILES_CFG}"
fi

# Actual dot-files
cd ${MACHINE_OS}
LINKS=('bashrc' 'bash_profile' 'bash_aliases' 'gitconfig' 'mackup.cfg' 'tmux.conf' 'tool-versions' 'vimrc')
OS_SPECIFIC_LINKS=( $(ls bash_*) )
cd -

function link_if_not_exists() {
  local FILE=${1}
  local DOT_FILE=${2:-"${FILE}"}
  local SOURCE_FILE="${GITROOT}/${FILE}"
  local TARGET_FILE="${HOME}/.${DOT_FILE}"
  if [[ -L "${TARGET_FILE}" || -e "${TARGET_FILE}" ]]; then
    local USER_REPLY
    msg_warn "${TARGET_FILE} exists" >&2
    read -p "Want me to overwrite it? " -n 1 -r USER_REPLY
    echo
    if [[ ${USER_REPLY} =~ ^[Yy]$ ]]; then
      ln -sf ${SOURCE_FILE} ${TARGET_FILE}
    fi
  else
    msg_info "Creating ${TARGET_FILE} symlink"
    ln -s ${SOURCE_FILE} ${TARGET_FILE}
  fi
}

for LINK in ${LINKS[@]}; do
  link_if_not_exists ${LINK}
done

for LINK in ${OS_SPECIFIC_LINKS[@]}; do
  link_if_not_exists "${MACHINE_OS}/${LINK}" ${LINK//_/_os_}
done

# Install everything else
function install_everything_else() {
  # Install asdf plugins and tools' versions
  install_asdf_tool_versions

  msg_info "Sourcing ${HOME}/.bashrc"
  disableStrictMode
  . ${HOME}/.bashrc
  strictMode

  # Running post-install steps
  . ${MACHINE_OS}/post-install
}

if [[ "${INSTALL_EVERYTHING:-''}" == 'y' ]]; then
  install_everything_else
  msg_info "I'm done!"
elif [[ "${INSTALL_EVERYTHING:-''}" == 'n' ]]; then
  msg_info "I'm done!"
else
  read -p "Want me to install everything else? " -n 1 -r USER_REPLY
  echo
  if [[ ${USER_REPLY} =~ ^[Yy]$ ]]; then
    install_everything_else
  else
    msg_info "I'm done!"
  fi
fi
