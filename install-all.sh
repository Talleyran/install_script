#!/bin/zsh
ruby='1.9.3'
mapserver='mapserver-6.0.2'
pgpass='514790'
name='Kirill Jakovlev'
email='special-k@li.ru'
githubuser=$USER
pguser=$USER
if [[ `egrep -o '[0-9]+\.[0-9]+' /etc/issue` > "11.04" ]]
then
  version=new
else
  version=old
fi


show_help() { 
  echo 'You can install:
    rsa
    system
    git
    vim
    ruby
    desktop
    gis
    mapscript

  usage:
    install-all [ prog1 prog2 ... [--except prog1 prog2 ... ] ]

  examples of usage:
    install-all vim ruby              - this install vim and ruby
    install-all --except vim ruby     - this install all except vim and ruby
    install-all                       - this install all'
 }


case $1 in
  --except) b=false
    ;;
  -ex) b=false
    ;;
  --help) 
      show_help
      exit 0
    ;;
  -h) 
      show_help
      exit 0
    ;;
  ?) 
      b=true
    ;;
esac

if $b
then
  not_b=false
else
  not_b=true
fi

rsa=$not_b
system=$not_b
git=$not_b
vim=$not_b
ruby=$not_b
desktop=$not_b
gis=$not_b
mapscript=$not_b

for i in $*
do
  case $i in
    rsa) rsa=$b
      ;;
    system) system=$b
      ;;
    git) git=$b
      ;;
    vim) vim=$b
      ;;
    ruby) ruby=$b
      ;;
    desktop) desktop=$b
      ;;
    gis) gis=$b
      ;;
    mapscript) mapscript=$b
      ;;
  esac
done

cd ~
#sudo
sudo echo We are sudo

#set shell
chsh -s /bin/zsh

#gen rsa
if $rsa;then
  ssh-keygen -t rsa
fi

# update & upgrade
sudo apt-get update
sudo apt-get dist-upgrade -y

#system
if $system;then
  rm -rf .oh-my-zsh #clean
  rm -f .zshrc #clean
  sudo apt-get install -y curl git-core mercurial
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  curl https://raw.github.com/Talleyran/install_script/master/files/special_dallas.zsh-theme > .oh-my-zsh/themes/special_dallas.zsh-theme
  curl https://raw.github.com/Talleyran/install_script/master/files/.zshrc > .zshrc
fi

#git
if $git;then
  git config --global --replace-all user.name "$name"
  git config --global --replace-all user.email "$email"
  git config --global --replace-all github.user "$githubuser"
fi

#vim
if $vim;then
  rm -rf .vim #clean
  rm -f .vimrc #clean
  sudo apt-get install -y vim-gnome
  git clone git@github.com:Talleyran/myvim.git ~/.vim
  cd ~/.vim
  git submodule init
  git submodule update
  cp ~/.vim/.vimrc ~/
  cp ~/.vim/.iabbrev ~/
  ln -s ~/.vim/vim-pathogen/autoload ~/.vim/autoload
  cd ~
fi

#ruby
if $ruby;then
  rm -rf .rvm #clean
  sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev libssl-dev libpq-dev libxml2 libxml2-dev libxslt-dev libmagickwand-dev
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
  source ~/.zshrc
  rvm install $ruby
  rvm use $ruby --default
  gem install bundler
fi

#desktop
if $desktop;then
  sudo apt-get install -y xclip vlc
  sudo apt-get purge -y totem banshee
  if [[ $version = new ]]
  then
    sudo add-apt-repository -y ppa:alexey-smirnov/deadbeef
    sudo add-apt-repository -y ppa:atareao/atareao
  else
    sudo add-apt-repository ppa:alexey-smirnov/deadbeef
    sudo add-apt-repository ppa:atareao/atareao
  fi
  sudo apt-get update
  sudo apt-get install -y deadbeef touchpad-indicator
fi

#postgres
if $postgres;then
  sudo apt-get install -y postgresql pgadmin3
  sudo -u postgres createuser -s special-k
  sudo -u postgres psql -c "alter role \"$pguser\" password '$pgpass';"
fi

#gis
if $gis;then
  if [[ $version = new ]]
  then
    sudo add-apt-repository -y ppa:alexey-smirnov/deadbeef
  else
    sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
  fi
  sudo apt-get update
  sudo apt-get install -y qgis mapserver-bin postgis postgresql-8.4-postgis
fi

#mapscript
if $mapscript;then
  rm -rf source/$mapserver
  rm -f source/$mapserver.tar.gz
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
fi

#autoclean
sudo apt-get autoclean
