function ccb --description 'Clear and cargo nightly build'
    clear; cargo +nightly build $argv
end
