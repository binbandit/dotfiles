# O-i-i fish shell integration

# Define the post-cd hook function
function _oii_post_cd --on-variable PWD
    # Skip tracking for certain directories
    switch $PWD
        case "*/node_modules*" "*/target/*" "*/.git/*" "*/tmp/*" "*/temp/*" "*/.cache/*"
            return 0
    end

    # Add directory in background
    command oii add "$PWD" 2>/dev/null &
    disown
end

# Enhanced integration with cd override
function cd
    set -l old_dir $PWD

    if test (count $argv) -eq 0
        # No arguments - go to home
        builtin cd
    else if test "$argv[1]" = "-"
        # Handle cd - with oii
        set -l dir (command oii jump - --raw 2>/dev/null)
        if test -n "$dir"
            set -gx OLDPWD $old_dir
            builtin cd $dir
        else
            builtin cd -
        end
    else if test -d "$argv[1]"
        # Directory exists - use normal cd
        set -gx OLDPWD $old_dir
        builtin cd $argv
    else
        # Try fuzzy jump with oii
        set -l dir (command oii jump $argv --raw 2>/dev/null)
        if test -n "$dir"
            set -gx OLDPWD $old_dir
            builtin cd $dir
        else
            builtin cd $argv
        end
    end
end

# Convenient aliases
alias oi="oii jump"
alias oii_i="oii interactive"

# Tab completion for oii
complete -c oii -f
complete -c oii -n "__fish_use_subcommand" -a "init add jump interactive list top remove clear import query stats"
complete -c oii -n "__fish_seen_subcommand_from jump" -a "(oii list -n 50 2>/dev/null | awk '{print \$2}' | sed 's/^~/\$HOME/')"
complete -c oi -f -a "(oii list -n 50 2>/dev/null | awk '{print \$2}' | sed 's/^~/\$HOME/')"