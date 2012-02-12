##!/bin/zsh
ruby=1.9.3
mapserver=mapserver-6.0.2
pgpass=514790
name=Kirill Jakovlev
email=special-k@li.ru
githubuser=$USER

cd ~

# update & upgrade
sudo apt-get update
sudo apt-get dist-upgrade


#system
ssh-keygen -t rsa
sudo apt-get install zsh curl git-core
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
https://raw.github.com/Talleyran/install_script/master/files/.vimrc
curl https://raw.github.com/Talleyran/install_script/master/files/special_dallas.zsh-theme > .oh-my-zsh/themes/special_dallas.zsh-theme
curl https://raw.github.com/Talleyran/install_script/master/files/.zshrc > .zshrc

#git
git config --global user.name $name
git config --global user.email $email
git config --global github.user $githubuser

#ruby
sudo apt-get install build-essential libssl-dev libreadline-dev zlib1g-dev libssl-dev libpq-dev libxml2 libxml2-dev libxslt-dev libmagickwand-dev
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
source ~/.zshrc
rvm install $ruby
rvm use $ruby --default

#vim
git clone git@github.com:Talleyran/myvim.git ~/.vim
cd ~/.vim
git submodule init
git submodule update
cp ~/.vim/.vimrc ~/
cp ~/.vim/.iabbrev ~/
ln -s ~/.vim/vim-pathogen/autoload ~/.vim/autoload
cd ~

#desktop
sudo apt-get install xclip
sudo apt-get install vlc
sudo apt-get purge totem
sudo apt-get purge banshee
sudo add-apt-repository ppa:alexey-smirnov/deadbeef
sudo apt-get update
sudo apt-get install deadbeef

#postgres
sudo apt-get install postgresql
sudo -u postgres createuser -s special-k
sudo -u postgres psql -c "alter role \"special-k\" password '$pgpass';"
sudo apt-get install pgadmin3

#gis
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install qgis
sudo apt-get install mapserver-bin

#mapscript
sudo apt-get install libfreetype6-dev libgif-dev libpng-dev libjpeg-dev libgdal-dev libgd2-xpm-dev libproj-dev libcurl4-openssl-dev libxslt-dev libghc6-cairo-dev swig
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
