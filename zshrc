eval "$(starship init zsh)"
# Theme settings
# export TYPEWRITTEN_DISABLE_RETURN_CODE=true

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Proxy trash
# export {all,http,https}_proxy=http://cba.proxy.prismaaccess.com:8080
# export no_proxy=.cba
# export HOMEBREW_ARTIFACT_DOMAIN="https://artifactory.internal.cba/artifactory/homebrew"
# export HOMEBREW_DOCKER_REGISTRY_TOKEN='cmVmd'


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --MARK: Proxies

export {all,http,https}_proxy=http://cba.proxy.prismaaccess.com:8080
export no_proxy=127.0.0.*,10.*,172.*,192.168.*,169.254.*,*.local,*.cba,*.cbainet.com,*.myappsanywhere.org,*.cba.com.au,*.github.com,github.com,.cba,192.168.1.128
export HTTPS_PROXY=cba.proxy.prismaaccess.com:8080
export https_proxy=cba.proxy.prismaaccess.com:8080
alias ProxyOn="export {all,http,https}_proxy=http://localhost:3128"
alias ProxyOff="unset {all,http,https}_proxy"

# --MARK: Paths
# Path additions
path+="${HOME}/Applications/bin"
path+="${HOME}/Library/Python/3.9/bin"
path+="${HOME}/Applications/nvim/bin"
path+="${HOME}/Applications/bin/zig"
path+="${HOME}/.local/bin"
path+="${HOME}/.npm-global/bin"
path+="${HOME}/Developer/go-lang/stack"
path+="${HOME}/.config/emacs/bin"
path+="${HOME}/go/bin"
# -- MARK: Aliases

# Developement aliases
alias yl="yarn list"
alias yad="yarn add -D"
alias ya="yarn add"
alias y="yarn"
alias yb="yarn build"
alias yd="yarn dev"
alias ys="yarn start"
alias yt="yarn test"

alias p="pnpm"
alias pad="pnpm add -D"
alias pa="pnpm add"
alias pb="pnpm build"
alias pd="pnpm dev"
alias ps="pnpm start"
alias pt="pnpm test"
alias pi="pnpm install"
alias pp='pnpm pack | xargs -I {} echo "$(pwd)/{}" | pbcopy'
alias po="pnpm orchestrator"

alias cpad="clear; pnpm add -D"
alias cpa="clear; pnpm add"
alias cpb="clear; pnpm build"
alias cpd="clear; pnpm dev"
alias cps="clear; pnpm start"
alias cpt="clear; pnpm test"
alias cpi="clear; pnpm install"
alias cpp='clear; pnpm pack | xargs -I {} echo "$(pwd)/{}" | pbcopy'
alias cpo="clear; pnpm orchestrator"

alias ppb="pnpm install; pnpm build"
alias ppd="pnpm install; pnpm dev"
alias pps="pnpm install; pnpm start"
alias ppt="pnpm install; pnpm test"
alias ppo="pnpm install; pnpm orchestrator"

alias cppb="clear; pnpm install; pnpm build"
alias cppd="clear; pnpm install; pnpm dev"
alias cpps="clear; pnpm install; pnpm start"
alias cppt="clear; pnpm install; pnpm test"
alias cppo="clear; pnpm install; pnpm orchestrator"

alias gs="git status"
alias gp="git pull"
alias gpu="git push"
alias gc="git commit -a -m"
alias ga="git add"

alias gr="go run"
alias gb="go build"

alias cgr="clear; go run"
alias cgb="clear; go build"

# alias c="carbon"

alias cwd="pwd | pbcopy"

alias z="emacsclient -c"
alias n="nvim"

alias s="stack"

alias c="cargo"
alias ca="cargo add"
alias cr="cargo run"
alias cb="cargo build"

alias combine="/Users/moonbr/Developer/go-lang/combine_files/combine_files"
alias squish="/Users/moonbr/Developer/shooting-range/squish/squish"
alias river="/Users/moonbr/Developer/go-lang/river/river"

alias x="pnpm dlx"
alias tap="/Users/moonbr/Developer/rust/tap/target/release/tap"
alias src="source ~/.zshrc"

alias gb="go build"
alias gm="go mod"
alias gi="go install"
alias gr="go run"
alias gt="go test"
alias gmt="go mod tidy"

alias l="eza --icons"
# --MARK: Exports

export NODE_EXTRA_CA_CERTS=/Users/moonbr/prisma2.cba.pem
export NODE_TLS_REJECT_UNAUTHORIZED=0
export GOPROXY=https://artifactory.internal.cba/api/go/gocenter-proxy
export DOCKER_OPTS=" --insecure-registry commsee-delivery-docker-dev-local.docker.internal.cba"
# This is for legacy applications like angular
# export NODE_OPTIONS=--openssl-legacy-provider
# export HTTPS_PROXY="http://proxy.au.eds.com:8080/"
export ARTIFACTOR_PASS=cmVmdGtuOjAxOjE3NDg5MDg1NTI6Z09BdmlTQ3ViMGcxT09xeTZFU0d0MHkxS2Zj
export ARTIFACTORY_TOKEN=cmVmdGtuOjAxOjE3NDg5MDg1NTI6Z09BdmlTQ3ViMGcxT09xeTZFU0d0MHkxS2Zj
export ARTIFACTORY_ENTERPRISE_NPM_AUTH_KEY=cmVmdGtuOjAxOjE3NDg5MDg1NTI6Z09BdmlTQ3ViMGcxT09xeTZFU0d0MHkxS2Zj
export ARTIFACTORY_ENTERPRISE_NPM_AUTH_TOKEN=cmVmdGtuOjAxOjE3NDg5MDg1NTI6Z09BdmlTQ3ViMGcxT09xeTZFU0d0MHkxS2Zj
export ARTIFACTORY_ENTERPRISE_APIKEY=cmVmdGtuOjAxOjE3NDg5MDg1NTI6Z09BdmlTQ3ViMGcxT09xeTZFU0d0MHkxS2Zj

# pnpm
export COREPACK_ENABLE_STRICT=0
export PNPM_HOME="/Users/moonbr/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
fpath=($fpath "/Users/moonbr/.zfunctions")

# Set typewritten ZSH as a prompt
# autoload -U promptinit; promptinit
# prompt typewritten
