# This file is sourced at the end of a first-time dotfiles install.
shopt -s expand_aliases
source ~/.bashrc

# I'm forgetful. Just look at this repo's commits to see how many times I
# forgot to setup Git and GitHub.
if exists wanip; then
    host=$(wanip)
else
    host=$HOSTNAME
fi

cat <<EOF
If this is a remote server, run:
ssh-copy-id $USER@$host && ssh $USER@$host
EOF
