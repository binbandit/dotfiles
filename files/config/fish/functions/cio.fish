function cio --description 'Cargo nightly install offline'
    cargo +nightly install --path . --offline $argv
end
