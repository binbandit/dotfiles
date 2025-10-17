function pp --description 'PNPM pack and copy path'
    pnpm pack | xargs -I {} echo (pwd)/{} | pbcopy
end
