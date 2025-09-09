function ccio --description 'Clear and cargo nightly install offline'
    clear; cargo +nightly install --path . --offline $argv
end
