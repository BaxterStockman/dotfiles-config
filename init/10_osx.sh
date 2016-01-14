# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Ensure that we can actually, like, compile anything.
if ! command -v gcc >/dev/null 2>&1; then
    fatal "XCode or the Command Line Tools for XCode must be installed first." 1>&2
    exit 1
fi

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  title "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if [[ "$(type -P brew)" ]]; then
  title "Updating Homebrew"
  brew doctor
  brew update

  # Install Homebrew recipes.
  recipes=(
    bash
    ssh-copy-id
    git git-extras hub
    tree sl id3tool cowsay
    lesspipe nmap
    htop-osx man2html
  )

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    title "Installing Homebrew recipes: $list"
    brew install $list
  fi

  # This is where brew stores its binary symlinks
  local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

  # htop
  if [[ "$(type -P $binroot/htop)" && "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
    title "Updating htop permissions"
    sudo chown root:wheel "$binroot/htop"
    sudo chmod u+s "$binroot/htop"
  fi

  # bash
  if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
    title "Adding $binroot/bash to the list of acceptable shells"
    echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
  fi
  if [[ "$SHELL" != "$binroot/bash" ]]; then
    title "Making $binroot/bash your default shell"
    sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
    msg2 "Please exit and restart all your shells."
  fi

  # i don't remember why i needed this?!
  if [[ ! "$(type -P gcc-4.2)" ]]; then
    title "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi
