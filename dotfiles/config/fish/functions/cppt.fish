function cppt --description 'Clear, PNPM install and test'
    clear; pnpm install; pnpm test $argv
end
