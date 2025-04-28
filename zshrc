eval "$(starship init zsh)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git)

source $ZSH/oh-my-zsh.sh

# --MARK: Paths
# Path additions
path+="${HOME}/Applications/bin"
path+="${HOME}/Applications"
path+="${HOME}/Library/Python/3.9/bin"
path+="${HOME}/Applications/nvim/bin"
path+="${HOME}/Applications/bin/zig"
path+="${HOME}/.local/bin"
path+="${HOME}/.npm-global/bin"
path+="${HOME}/Developer/go-lang/stack"
path+="${HOME}/.config/emacs/bin"
path+="${HOME}/go/bin"
path+="${HOME}/miniconda3/bin"
path+="${HOME}/developer/go-lang/goshed/_auto"
path+="${HOME}/Developer/rust/zoop/target/release"
path+="${HOME}/Developer/rust/foreach/target/release"
path+="${HOME}/Developer/zig/zig/build/stage3/bin"
path+="${HOME}/Developer/zig/zls/zig-out/bin"
path+="${HOME}/.goshed/projects/stacking/bin"
path+="${HOME}/Developer/go-lang/strata-latest"
path+="${HOME}/Developer/rust/splat/target/debug/"
path+="${HOME}/Developer/go-lang/sparrow/bin/"
path+="/Users/brayden/Developer/native/ghidra/build/dist/ghidra_11.4_DEV"
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
alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"

alias gr="go run"
alias gb="go build"

alias cgr="clear; go run"
alias cgb="clear; go build"

# alias c="carbon"

alias cwd="pwd | pbcopy"

# alias z="emacsclient -c"
# alias zz="/Users/brayden/Developer/go-lang/zing/build/bin/zing"
alias z="zyra"
alias n="nvim"

# alias s="sparrow"
alias s="sage"

alias c="cargo"
alias cv="cargo vendor"
alias ca="cargo add"
alias cr="cargo run"
alias cb="cargo build"
alias ci="cargo install --path . --offline"
alias ct="cargo test"

alias cc="clear; cargo"
alias ccv="clear; cargo vendor"
alias cca="clear; cargo add"
alias ccr="clear; cargo run"
alias ccb="clear; cargo build"
alias cci="clear; cargo install --path . --offline"
alias cct="clear; cargo test"


alias g="/Users/brayden/Developer/go-lang/glue/build/bin/glue"
alias glue="/Users/brayden/Developer/go-lang/glue/build/bin/glue"
alias squish="/Users/brayden/Developer/go-lang/squish/squish"
# alias river="/Users/moonbr/Developer/go-lang/river/river"

alias x="pnpm dlx"
alias xx="pnpm dlx tsx"
alias src="source ~/.zshrc"

alias gb="go build"
alias gm="go mod"
alias gi="go install"
alias gr="go run"
alias gmt="go mod tidy"

alias l="eza --icons"
alias f="ls | grep "

alias surf="windsurf"
# --MARK: Exports

export OPENAI_API_KEY=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
export NODE_TLS_REJECT_UNAUTHORIZED=0

# pnpm
export PNPM_HOME="/Users/brayden/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
fpath=($fpath "/Users/moonbr/.zfunctions")

# Zoop init
eval "$(zoop init)"

# Set typewritten ZSH as a prompt
# autoload -U promptinit; promptinit
# prompt typewritten

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/brayden/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/brayden/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/brayden/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/brayden/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export PATH="$PATH:/Users/brayden/.bin"
export SAGE_GITHUB_TOKEN="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"
export HF_TOKEN="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"
source ~/.sage-completion.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
