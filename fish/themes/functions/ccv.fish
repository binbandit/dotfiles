function ccv --description 'Clear and cargo nightly vendor'
    clear; cargo +nightly vendor $argv
end
