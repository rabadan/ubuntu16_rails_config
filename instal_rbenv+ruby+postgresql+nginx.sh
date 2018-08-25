#!/bin/sh 
fuser -vki /var/lib/dpkg/lock
# install rbenv ruby and rails
echo 'update system'
echo "--------------------------------------------------"
apt-get -y update
echo 'install packeges'
echo "--------------------------------------------------"
apt-get -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev libmagickwand-dev postgresql postgresql-contrib libpq-dev sqlite3 libsqlite3-dev imagemagick

echo 'download rbenv'
echo "--------------------------------------------------"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'install ruby'
echo "--------------------------------------------------"
$HOME/.rbenv/bin/rbenv install 2.5.0
$HOME/.rbenv/bin/rbenv global 2.5.0
echo "gem: --no-document" > ~/.gemrc
echo "install bundler"
echo "--------------------------------------------------"
$HOME/.rbenv/shims/gem install bundler
echo "install rails"
echo "--------------------------------------------------"
$HOME/.rbenv/shims/gem install rails

echo "install nodejs"
echo "--------------------------------------------------"
cd /tmp
\curl -sSL https://deb.nodesource.com/setup_6.x -o nodejs.sh
cat /tmp/nodejs.sh | sudo -E bash -
apt-get -y install nodejs

#!/bin/sh 
fuser -vki /var/lib/dpkg/lock
# install rbenv ruby and rails
echo 'update system'
echo "--------------------------------------------------"
apt-get -y update
# step 1
echo 'install packeges'
echo "--------------------------------------------------"
apt-get install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get -y update
apt-get install -y nginx-extras passenger

# step 2
sed -i -e 's/\# include \/etc\/nginx\/passenger.conf/include \/etc\/nginx\/passenger.conf/g' /etc/nginx/nginx.conf
service nginx restart

# step 3
/usr/bin/passenger-config validate-install --auto
/usr/sbin/passenger-memory-stats

# step 4
apt-get -y update
apt-get -y upgrade

# step 5

echo -n > /etc/nginx/passenger.conf
echo "passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;" >> /etc/nginx/passenger.conf
echo "passenger_ruby "$HOME"/.rbenv/shims/ruby;" >> /etc/nginx/passenger.conf
service nginx restart