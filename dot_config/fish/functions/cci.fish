function cci --description 'Clear and cargo nightly install'
    clear; cargo +nightly install --path . $argv
end
