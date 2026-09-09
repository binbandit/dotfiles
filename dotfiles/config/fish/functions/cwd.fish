function cwd --description 'Copy working directory to clipboard'
  printf '%s' (string escape -- $PWD) | pbcopy
end
