wants=(
    i3-wm
    conky
    feh
)

for pkg in ${wants[@]}; do
    exists $pkg || pacman -Qss $pkg || sudo pacman -S $package
done
