if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Homebrew initialization (Apple Silicon)
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# PATH modifications
fish_add_path $HOME/Applications/bin
fish_add_path $HOME/Applications
fish_add_path $HOME/Library/Python/3.9/bin
fish_add_path $HOME/Applications/nvim/bin
fish_add_path $HOME/Applications/bin/zig
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/bob/nvim-bin
fish_add_path $HOME/.npm-global/bin
fish_add_path $HOME/Developer/go-lang/stack
fish_add_path $HOME/.config/emacs/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/miniconda3/bin
fish_add_path $HOME/developer/go-lang/goshed/_auto
fish_add_path $HOME/Developer/rust/zoop/target/release
fish_add_path $HOME/Developer/rust/foreach/target/release
fish_add_path $HOME/Developer/zig/zig/build/stage3/bin
fish_add_path $HOME/Developer/zig/zls/zig-out/bin
fish_add_path $HOME/.goshed/projects/stacking/bin
fish_add_path $HOME/Developer/go-lang/strata-latest
fish_add_path $HOME/Developer/rust/splat/target/debug/
fish_add_path $HOME/Developer/go-lang/sparrow/bin/
fish_add_path $HOME/.bin

# Initialize starship prompt
if type -q starship
    starship init fish | source
end

# zoxide init
if type -q zoxide
    set -gx _ZO_EXCLUDE_DIRS '**/node_modules/**:**/target/**:**/.git/**:**/tmp/**:**/temp/**:**/.cache/**'
    zoxide init fish --cmd=cd | source
    alias oi 'z'
    alias oii 'zoxide'
end

# PNPM
set -gx PNPM_HOME "/Users/brayden/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Cargo/Rust
fish_add_path $HOME/.cargo/bin

# Environment variables
set -gx OPENAI_API_KEY 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
set -gx NODE_TLS_REJECT_UNAUTHORIZED 0
set -gx SAGE_GITHUB_TOKEN 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
set -gx HF_TOKEN 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

# rbenv init
if type -q rbenv
    rbenv init - fish | source
end

# Kiro shell integration
if test "$TERM_PROGRAM" = "kiro"
    source (kiro --locate-shell-integration-path fish)
end

# Google Cloud SDK
if test -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
    source '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
end

# Bell after command (fish equivalent of precmd)
function fish_postexec
    echo -ne '\a'
end

# Antheia Shell Prompt (if available)
# if test -d "$HOME/.antheia"
#     fish_add_path $HOME/.antheia
#     # Start Antheia daemon if not running
#     if test -x "$HOME/.antheia/start_daemon.sh"
#         $HOME/.antheia/start_daemon.sh
#     end
# end

