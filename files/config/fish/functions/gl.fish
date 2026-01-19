function gl --description 'Git log with graph'
    git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n' $argv
end
