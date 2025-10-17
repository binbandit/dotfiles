function up-or-search --description 'Search back or move cursor up 1 line'
    # If we are already in search mode, continue searching backwards
    if commandline --search-mode
        commandline -f history-search-backward
        return
    end

    # Navigating the pager should always move the cursor up
    if commandline --paging-mode
        commandline -f up-line
        return
    end

    # Otherwise, start a history search from the first line
    switch (commandline -L)
        case 1
            commandline -f history-search-backward
        case '*'
            commandline -f up-line
    end
end
