# Check that we're on Arch
[[ "$(< /etc/issue)" =~ ^Arch ]] || return 1

if ! pacman -Qqs curl &>/dev/null; then
  title "Installing curl"
  pacman -S curl
fi

if ! pacman -Qqs packer &>/dev/null; then
  title "Installing Packer"
  PACKER_PKGBUILD_URL="https://aur.archlinux.org/packages/pa/packer/PKGBUILD"
  CWD=$(pwd)
  BUILD_DIR="$CWD/packer"
  mkdir -p $BUILD_DIR
  cd $BUILD_DIR
  curl -L -o PKGBUILD $PACKER_PKGBUILD_URL
  makepkg -s PKGBUILD
  PACKER_PKG=$(ls -1 packer*pkg.tar.xz | head -1)
  sudo pacman -U $PACKER_PKG
  cd $CWD
  rm -rf $BUILD_DIR
fi

# Upgrade existing packages
title "Updating packages"
cat <<EOF
Would you like to upgrade installed packages?

This will be skipped if "Y" isn't pressed within the next 15 seconds.
EOF
read -r -n 1 -t 15 -p "Upgrade packages? [y/N] " upgrade_packages
echo
if [[ "$upgrade_packages" =~ [Yy] ]]; then
    title "Upgrading packages"
    if packer -Syu; then
        echo "Upgraded packages."
    else
        echo "Error upgrading packages"
    fi
else
    echo "Skipping."
fi
