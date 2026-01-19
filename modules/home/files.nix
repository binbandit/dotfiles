{ ... }:

{
  xdg.configFile."fish/conf.d".source = ../../files/config/fish/conf.d;
  xdg.configFile."fish/functions".source = ../../files/config/fish/functions;
  xdg.configFile."fish/completions".source = ../../files/config/fish/completions;

  xdg.configFile."ghostty".source = ../../files/config/ghostty;
  xdg.configFile."helix".source = ../../files/config/helix;
  xdg.configFile."nvim".source = ../../files/config/nvim;
  xdg.configFile."tmux".source = ../../files/config/tmux;
  xdg.configFile."zed".source = ../../files/config/zed;

  home.file.".doom.d".source = ../../files/doom.d;
}
