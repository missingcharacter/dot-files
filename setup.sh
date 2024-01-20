#!/usr/bin/env bash
# Enable bash's unofficial strict mode
GITROOT=$(git rev-parse --show-toplevel)
# shellcheck disable=SC1091
. "${GITROOT}"/lib/strict-mode
strictMode
# shellcheck disable=SC1091
. "${GITROOT}"/lib/utils

THIS_SCRIPT=$(basename "${0}")
PADDING=$(printf %-${#THIS_SCRIPT}s " ")

function usage() {
    msg_info "Usage:"
    msg_info "${THIS_SCRIPT} -i, --install-everything <Use this flag to install everything>"
    msg_info "${PADDING} -y, --yes <Use this flag to answer yes to all questions>"
    echo
    msg_info "Sets up base macOS and Ubuntu system"
    exit 1
}

# Ensure dependencies are present
if ! command -v git &>/dev/null; then
    msg_fatal "[-] Dependencies unmet. Please verify that the following are installed and in the PATH: git"
fi


MACHINE_OS="$(get_operatingsystem)"

if [[ "${MACHINE_OS}" == 'Ubuntu' ]]; then
  export DEBIAN_FRONTEND='noninteractive'
fi

INSTALL_EVERYTHING='n'
ASK='y'
while [[ $# -gt 0 ]]; do
  case "${1}" in
    -i|--install-everything)
      INSTALL_EVERYTHING='y'
      shift # past argument
      ;;
    -y|--yes)
      ASK='n'
      shift # past argument
      ;;
    -h|--help)
      usage
      ;;
    -*)
      echo "Unknown option ${1}"
      usage
      ;;
  esac
done

# Installing basics
# shellcheck disable=SC1090,SC1091
. "${GITROOT}/${MACHINE_OS}/base"
is_asdf_installed "${ASK}"

# Setting up mackup
MACKUP_CUSTOM_APPS_DIR="${HOME}/.mackup"
create_dir_if_not_exists "${MACKUP_CUSTOM_APPS_DIR}"

MY_MACKUP_CFG="my-files.cfg"
link_if_not_exists "${GITROOT}/${MY_MACKUP_CFG}" "${MACKUP_CUSTOM_APPS_DIR}/${MY_MACKUP_CFG}"

# Actual dot-files
declare -a LINKS=(
  'bashrc'
  'bash_profile'
  'bash_aliases'
  'envrc'
  'gitconfig'
  'mackup.cfg'
  'ohmyposh.json'
  'tmux.conf'
  'tool-versions'
)

for LINK in "${LINKS[@]}"; do
  link_if_not_exists "${GITROOT}/${LINK}" "${HOME}/.${LINK}"
done

# neovim
link_if_not_exists "${GITROOT}/nvim" "${HOME}/.config/nvim"

# alacritty
link_if_not_exists "${GITROOT}/alacritty" "${HOME}/.config/alacritty"

declare -a OS_SPECIFIC_LINKS=()
mapfile -t OS_SPECIFIC_LINKS < <(get_os_specific_links "${MACHINE_OS}")

for LINK in "${OS_SPECIFIC_LINKS[@]}"; do
  link_if_not_exists "${GITROOT}/${MACHINE_OS}/${LINK}" "${HOME}/.${LINK//_/_os_}"
done

if [[ "${INSTALL_EVERYTHING}" == 'y' ]]; then
  install_everything_else
fi

msg_info "I'm done!"
