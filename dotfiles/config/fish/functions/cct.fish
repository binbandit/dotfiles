function cct --description 'Clear and cargo nightly nextest'
    clear; cargo +nightly nextest $argv
end
