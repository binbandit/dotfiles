function ci --description 'Cargo nightly install'
    cargo +nightly install --path . $argv
end
