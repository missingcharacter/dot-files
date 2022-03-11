# Personal dot files and computer configuration

Keep key configurations and share them among your computers

## Packages to install based on OS

### Ubuntu & MacOS

- Installs:
  - [1password-cli](https://support.1password.com/command-line/)
  - [asdf](https://github.com/asdf-vm/asdf)
  - [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  - [oh-my-posh](https://ohmyposh.dev)
  - [bfg](https://rtyley.github.io/bfg-repo-cleaner/)
  - [docker](https://docs.docker.com/install/)
  - [fpp](https://github.com/facebook/PathPicker)
  - [gawk](https://www.gnu.org/software/gawk/)
  - [git-filter-repo](https://github.com/newren/git-filter-repo)
  - [gnupg](https://gnupg.org/)
  - [JetBrains Mono font](https://www.jetbrains.com/lp/mono/)
  - [jq](https://stedolan.github.io/jq/)
  - [inetutils](https://www.gnu.org/software/inetutils/)
  - [mackup](https://github.com/lra/mackup)
  - [parallel](https://www.gnu.org/software/parallel/)
  - [Nerd Fonts](https://www.nerdfonts.com)
  - [pinta](https://pinta-project.com/pintaproject/pinta/)
  - [Private Internet Access](https://www.privateinternetaccess.com/pages/download)
  - [rclone](https://rclone.org/)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [saml2aws](https://github.com/Versent/saml2aws)
  - [shellcheck](https://www.shellcheck.net/)
  - [spotify](https://www.spotify.com/us/download/other/)
  - [sublime text](https://www.sublimetext.com/3)
  - [tmux](https://tmux.github.io/)
  - [tree](http://mama.indstate.edu/users/ice/tree/)
  - [vim](https://www.vim.org/)
  - [visual studio code](https://code.visualstudio.com/)
  - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  - [vlc](https://www.videolan.org/vlc/)
  - [wget](https://www.gnu.org/software/wget/)
  - [wireshark](https://www.wireshark.org)
  - [xz](https://tukaani.org/xz/)

### MacOS

- Installs:
  - [Homebrew](https://brew.sh/)
    - cask installs:
      - [alfred](https://www.alfredapp.com/)
      - [bartender](https://www.macbartender.com/)
      - [Google Backup and Sync](https://www.google.com/drive/download/)
      - [iterm2](https://www.iterm2.com/)
      - [JDownloader](http://jdownloader.org/)
      - [MacDown](https://macdown.uranusjr.com/)
      - [Proxyman](https://proxyman.app/)
      - [Rectangle](https://rectangleapp.com/)
      - [tunnelblick](https://www.tunnelblick.net/)
  - [mas](https://github.com/mas-cli/mas)
    - [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12)
    - [Downcast](http://www.downcastapp.com/)
    - [Greenshot](https://getgreenshot.org/downloads/)
    - [Keka](https://www.keka.io/en/)

### Ubuntu

- Installs:
  - [Homebrew](https://brew.sh)
    - [mitmproxy](https://mitmproxy.org/downloads/)
  - [apt](https://wiki.debian.org/Apt)
    - [apt-file](https://wiki.debian.org/apt-file)
    - [ghostwriter](https://wereturtle.github.io/ghostwriter/)
    - [libxml2-utils](http://xmlsoft.org)
    - [Network Manager OpenVPN](https://gitlab.gnome.org/GNOME/NetworkManager-openvpn)
    - [python3-keyring](https://pypi.org/project/keyring/)
    - [xclip](https://github.com/astrand/xclip)

### Stuff I may replace

- Virtualbox with [multipass](https://multipass.run/) or
  [xhyve](https://github.com/machyve/xhyve), `xhyve` if I need windows hosts

## how I use mackup

- `~/.mackup.cfg` uses directory `~/.dot-files-rclone` with engine `file_system`
- Contents of `~/.dot-files-rclone` are encrypted and then  backed up to google
  drive using `rclone`
- `~/.config/rclone/rclone.conf` is encrypted

### To restore other configs

- Files `~/.mackup.cfg`, `~/.mackup/my-files.cfg` and
  `~/.config/rclone/rclone.conf` should be in your system
- Directory `~/.dot-files-rclone` should be created
- Run

  ```shell
  rclone copy -v --password-command "/path/to/script/that/outputs/password.sh" \
    "dot-files:${MACHINE_OS}" \
    ~/.dot-files-rclone/ # MACHINE_OS can be MacOS or Ubuntu`
  ```

- Run `mackup restore`

**Note:** I may try to replace `rclone copy/sync` with `rclone mount`, for the
moment I did not want to add another dependency (`osxfuse`)

## Places I borrowed stuff from

- <https://gist.github.com/millermedeiros/6615994>
- <https://gist.github.com/orlando/3991bd633b443078176f>
- <https://github.com/mathiasbynens/dotfiles>
- <https://github.com/nicolashery/mac-dev-setup>
- <https://github.com/danvega/new-macbook-setup>
- <https://github.com/geerlingguy/dotfiles>
- <https://www.lifewire.com/use-macs-hidden-finder-path-bar-2260868>
