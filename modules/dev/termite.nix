# Adapted from https://github.com/thumphries/nix-config/blob/master/termite/default.nix

{ stdenv, lib, termite, symlinkJoin, writeTextFile, makeWrapper, config ? {} }:

let defaultConfig = {
      font-face = "Monospace";
      font-size = 10;
      scrollback = 10000;
      browser = "google-chrome";
      # "off", "left" or "right"
      scrollbar = "off";
      alpha = 0.9;
    };

    cfg = lib.recursiveUpdate defaultConfig config;

    config-file = writeTextFile {
      name = "termite-config-file";
      executable = false;
      destination = "/etc/termite.conf";
      text = ''
        [options]
        font = ${cfg.font-face} ${ toString cfg.font-size }
        allow_bold = true
        clickable_url = true
        hyperlinks = true
        dynamic_title = true
        scrollback_lines = ${ toString cfg.scrollback }
        # "system", "on" or "off"
        cursor_blink = system
        cursor_shape = block
        browser = ${cfg.browser}
        scrollbar = ${cfg.scrollbar}

        [colors]
        background = rgba(83, 83, 83, ${ toString cfg.alpha })

        # If unset, will reverse foreground and background
        highlight = #2f2f2f

        # Colors from color0 to color254 can be set
        color0 = #3f3f3f
        color1 = #a26868
        color2 = #60b48a
        color3 = #dfaf8f
        color4 = #506070
        color5 = #dc8cc3
        color6 = #8cd0d3
        color7 = #dcdccc
        color8 = #709080
        color9 = #dca3a3
        color10 = #c3bf9f
        color11 = #f0dfaf
        color12 = #94bff3
        color13 = #ec93d3
        color14 = #93e0e3
        color15 = #ffffff

        [hints]
        font = ${cfg.font-face} ${ toString cfg.font-size }
        # vim: ft=dosini cms=#%s
      '';
    };
in symlinkJoin {
  name = "termite-bds";
  paths = [ config-file termite ];
  buildInputs = [ termite makeWrapper ];
  postBuild = ''
    echo $out
    echo $config-file
    wrapProgram $out/bin/termite \
      --add-flags --config=${config-file}/etc/termite.conf
  '';
}
