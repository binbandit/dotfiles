function nuke --description 'Git reset hard and clean'
    git reset --hard HEAD && git clean -fd
end
