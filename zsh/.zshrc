# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/grigorevan/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="iganosaigo"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    docker-compose
    poetry
    kubectl
    kube-ps1
    helm
    vagrant
    minikube
)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export PATH="$HOME/neovim/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.poetry/bin:$PATH"


if [[ $TILIX_ID ]]; then
    source /etc/profile.d/vte.sh
fi

# >>>> Vagrant command completion (start)
fpath=(/usr/share/rubygems-integration/all/gems/vagrant-2.2.19/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)

export PATH="$HOME/yandex-cloud/bin:$PATH"
if [ -f "${HOME}/yandex-cloud/completion.zsh.inc" ]; then source "${HOME}/yandex-cloud/completion.zsh.inc"; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
complete -o nospace -C ${HOME}/bin/packer.io packer
complete -C '/usr/local/bin/aws_completer' aws

export PATH="$HOME/.krew/bin:$PATH"

alias vim="nvim"
alias c="clear"
alias myip="curl ifconfig.co"

alias k="kubectl"
alias m="minikube"
alias mk="minikube kubectl --"
alias kct="kubectx"
alias kns="kubens"
alias p="pulumi"
alias t="terraform"

function kenv() {
    for config in $HOME/.kube/*_config ; do
        export KUBECONFIG="$KUBECONFIG:$config"
    done
}

function kenable() {
    KUBE_PS1_PREFIX='' 
    KUBE_PS1_SYMBOL_ENABLE=true
    KUBE_PS1_SEPARATOR=''
    KUBE_PS1_SUFFIX=' '
    KUBE_PS1_NS_COLOR=green
    KUBE_PS1_DIVIDER=' ➜ '
    KUBE_PS1_CTX_COLOR=magenta
    kubeon
    #PROMPT='$(kube_ps1)%1~ '
    PROMPT='$(kube_ps1)@ %{$fg[cyan]%}%1~%{$reset_color%} '
}

function kdisable() {
    kubeoff
    source $HOME/.oh-my-zsh/themes/iganosaigo.zsh-theme
}

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/completions/
autoload -U compinit && compinit

export PATH=$PATH:$HOME/.pulumi/bin
source <(pulumi gen-completion zsh)

export XDG_RUNTIME_DIR="/run/user/$UID"
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
