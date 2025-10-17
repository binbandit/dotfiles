function down-or-search --description 'Search forward or move cursor down 1 line'
    # If we are already in search mode, continue searching forwards
    if commandline --search-mode
        commandline -f history-search-forward
        return
    end

    # Navigating the pager should always move the cursor down
    if commandline --paging-mode
        commandline -f down-line
        return
    end

    # Otherwise, start a history search from the last line
    set -l lineno (commandline -L)
    set -l line_count (count (commandline))

    switch $lineno
        case $line_count
            commandline -f history-search-forward
        case '*'
            commandline -f down-line
    end
end
