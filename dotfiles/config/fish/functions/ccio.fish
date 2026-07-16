function ccio --description 'Clear and cargo nightly install offline'
    clear; cargo install --path . --offline $argv
end
