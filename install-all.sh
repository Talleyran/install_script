#!/bin/zsh
ruby='1.9.3'
mapserver='mapserver-6.0.2'
pgpass='514790'
name='Kirill Jakovlev'
email='special-k@li.ru'
githubuser=$USER
pguser=$USER

cd ~

#clean
rm -rf .vim
rm -f .vimrc
rm -rf .oh-my-zsh
rm -f .zshrc
rm -rf source/$mapserver
rm -f source/$mapserver.tar.gz
rm -rf .rvm

#sudo
sudo echo Now sudo

#set shell
chsh -s /bin/zsh

#gen rsa
ssh-keygen -t rsa

# update & upgrade
sudo apt-get update
sudo apt-get dist-upgrade -y

#system
sudo apt-get install -y curl git-core
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
curl https://raw.github.com/Talleyran/install_script/master/files/special_dallas.zsh-theme > .oh-my-zsh/themes/special_dallas.zsh-theme
curl https://raw.github.com/Talleyran/install_script/master/files/.zshrc > .zshrc

#git
git config --global --replace-all user.name "$name"
git config --global --replace-all user.email "$email"
git config --global --replace-all github.user "$githubuser"

#vim
git clone git@github.com:Talleyran/myvim.git ~/.vim
cd ~/.vim
git submodule init
git submodule update
cp ~/.vim/.vimrc ~/
cp ~/.vim/.iabbrev ~/
ln -s ~/.vim/vim-pathogen/autoload ~/.vim/autoload
cd ~

#ruby
sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev libssl-dev libpq-dev libxml2 libxml2-dev libxslt-dev libmagickwand-dev
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
source ~/.zshrc
rvm install $ruby
rvm use $ruby --default
gem install bundler

#desktop
sudo apt-get install -y xclip vlc
sudo apt-get purge -y totem banshee
sudo add-apt-repository -y ppa:alexey-smirnov/deadbeef
sudo apt-get update
sudo apt-get install -y deadbeef

#postgres
sudo apt-get install -y postgresql pgadmin3
sudo -u postgres createuser -s special-k
sudo -u postgres psql -c "alter role \"$pguser\" password '$pgpass';"

#gis
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install -y qgis mapserver-bin postgres postgis postgres-8.4-postgis

#mapscript
sudo apt-get install -y libfreetype6-dev libgif-dev libpng-dev libjpeg-dev libgdal-dev libgd2-xpm-dev libproj-dev libcurl4-openssl-dev libxslt-dev libghc6-cairo-dev swig
if [ ! -d ~/source ]; then
  mkdir ~/source
fi
cd ~/source
curl http://download.osgeo.org/mapserver/$mapserver.tar.gz > $mapserver.tar.gz
tar xvzf $mapserver.tar.gz
cd $mapserver
./configure --with-gdal=/usr/bin/gdal-config \
--with-ogr=/usr/bin/gdal-config \
--with-wfsclient \
--with-wmsclient \
--with-curl-config=/usr/bin/curl-config \
--with-proj=/usr/ \
--with-tiff \
--with-jpeg \
--with-freetype=/usr/ \
--with-threads \
--with-wcs \
--with-postgis=yes \
--with-libiconv=/usr \
--with-geos=/usr/bin/geos-config \
--with-xml2-config=/usr/bin/xml2-config \
--with-sos \
--without-agg-svg-symbols \
--with-cairo=yes \
--with-kml=yes \
--with-exslt
make
cd mapscript/ruby
ruby ./extconf.rb
make
for i in $(ruby -e 'puts $LOAD_PATH')
do
  for j in $(find $i -maxdepth 1 -name '*.so')
  do
    cp *.so $i/
    break
  done
done
cd ~

#autoclean
sudo apt-get autoclean
