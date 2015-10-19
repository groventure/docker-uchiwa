set -e
groupadd -r uchiwa
useradd -rm -g uchiwa -d /var/lib/uchiwa -s /sbin/nologin uchiwa
chown -Rv uchiwa:uchiwa /var/lib/uchiwa
install -dZvm 0775 -o root -g uchiwa /etc/uchiwa

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  git \
  nodejs \
  npm

ln -svf /usr/bin/nodejs /usr/bin/node

apt-get autoremove -y
apt-get clean

rm -rvf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*
set +e
