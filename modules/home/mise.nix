{ lib, defaults, hostConfig, ... }:

let
  miseDefaults = defaults.mise or { };
  miseHost = hostConfig.mise or { };
  tools = (miseDefaults.tools or { }) // (miseHost.tools or { });
  toolNames = lib.sort (a: b: a < b) (builtins.attrNames tools);
  formatKey = name:
    if builtins.match "^[0-9A-Za-z_-]+$" name != null then name else "\"${name}\"";
  toolLines = map (name: "${formatKey name} = \"${tools.${name}}\"") toolNames;
  configText = "[tools]\n" + (lib.concatStringsSep "\n" toolLines) + "\n";
in
{
  xdg.configFile."mise/config.toml".text = configText;
}
