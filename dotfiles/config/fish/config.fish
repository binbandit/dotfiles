# Keep this file minimal; see conf.d for the real config.

# Add Emacs bin to PATH if it exists
if test -d ~/.config/emacs
    fish_add_path ~/.config/emacs/bin
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/brayden/.lmstudio/bin
# End of LM Studio CLI section

