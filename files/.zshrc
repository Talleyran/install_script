# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="special_dallas"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(rake git mercurial vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
alias reso="source ~/.zshrc"

alias bi="bundle install"
alias bu="bundle update"
alias be="bundle exec"
alias bea="bundle exec autoload"
alias bet="bundle exec thin"

alias addppa="sudo add-apt-repository"
alias aptup="sudo apt-get update"
alias aptgr="sudo apt-get upgrade"
alias aptsgr="sudo apt-get dist-upgrade"
alias apti="sudo apt-get install"

alias r="rails"

alias gsvim='gvim --servername onevim'
alias gsvimadd='gsvim --remote'
alias v='gvim -f &'

alias unmdb='sudo rm /var/lib/mongodb/mongod.lock'
alias rgs='sudo service geoserver start'
alias stgs='sudo service geoserver stop'
alias regs='sudo service geoserver restart'
alias rmdb='sudo service mongodb start'
alias stmdb='sudo service mongodb stop'
alias remdb='sudo service mongodb restart'

alias ry='rsync --progress --delete-after'

#git
alias gg='git log --graph --date-order -C -M --pretty=format:"<%h> %ad [%an] %Cgreen%d%Creset %s" --all --date=short'
alias ggg='git log --walk-reflogs'
alias gggg='gitk --all $(git log --walk-reflogs --pretty=format:%h)'
alias gr='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias grs='git reset HEAD'
alias grsh='git reset --hard'
alias gcur='git rev-parse HEAD'
alias gcam='git commit --amend'
alias gar="git add .&&git ls-files --deleted | xargs git rm"
alias gar="git add .&&git ls-files --deleted | xargs git rm"
alias gd="git diff"
alias gdh="git diff HEAD"
alias gsi="git submodule init"
alias gsu="git submodule update"

alias hids="history | grep"

alias xclip='xclip -selection c'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
