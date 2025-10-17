function cpp --description 'Clear, PNPM pack and copy path'
    clear; pnpm pack | xargs -I {} echo (pwd)/{} | pbcopy
end
