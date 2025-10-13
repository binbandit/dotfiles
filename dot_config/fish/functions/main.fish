function main --description 'Sapling work on main'
    if type -q sg
        sg work -f main $argv
    end
end
