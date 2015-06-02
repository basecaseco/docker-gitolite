# start.sh
#
# VERSION: 0.1
#
# AUTHOR:    Ye Liu
# CONTACT:   yeliu@instast.com
# LICENSE:   MIT
# COPYRIGHT: Copyright (c) 2015 Ye Liu

SSHD='/usr/sbin/sshd'
KEYFILE='/tmp/admin_key.pub'
GITHOME='/home/git'
REPODIR="$GITHOME/repositories"

if [ -z "$SSH_KEY" ]; then
    echo 'error: missing SSH_KEY envrionment variable'
    exit 1
else
    echo "$SSH_KEY" > $KEYFILE
fi

if [ -d "$REPODIR" ]; then
    chown git:git -R "$REPODIR"
fi

su -c "$GITHOME/bin/gitolite setup -pk $KEYFILE" - git
if [ $? -eq 0 ]; then
    echo 'gitolite is ready, starting sshd...'
    rm $KEYFILE
    cat <<EOF > $0
chown git:git -R "$REPODIR"
exec "$SSHD" -D
EOF
    exec "$SSHD" -D
else
    echo 'error: initializing gitolite failed'
    rm $KEYFILE
    rm -rf "$GITHOME/{.gitolite*,.ssh,projects.list,repositories/*}"
    exit 1
fi