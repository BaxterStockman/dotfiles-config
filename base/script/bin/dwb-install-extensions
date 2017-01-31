exists dwb || return 1

extensions=(
  adblock_subscriptions
  downloadhandler
  googlebookmarks
  googledocs
  requestpolicy
  userscripts
)

for extension in ${extensions[@]}; do
  dwbem -i "$extension"
done
