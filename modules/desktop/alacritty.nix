{ stdenv, lib, pkgs, ...  } :

let cfg = {
      window.decorations = "full";
      scrolling.history = 10000;
      tabspaces = 4;
      font = {
        normal.family = "Fira Code";
        bold.family = "Fira Code";
        italic.family = "Fira Code";
        text = 10.0;
        offset = { x = 0; y = 0; };
      };
      draw_bold_text_with_bright_colors = true;
      colors = {
        primary = {
          background = "0x434343";
          foreground = "0xececec";
        };
        normal = {
          black = "0x000000";
          red = "0xc62828";
          green = "0x558b2f";
          yellow = "0xf9a825";
          blue = "0x1565c0";
          magenta = "0x6a1e9a";
          cyan = "0x00838f";
          white = "0xf2f2f2";
        };
      };
    };

    config-file = pkgs.writeTextFile {
      name = "alacritty-config-file";
      executable = false;
      # Relative to the derivation created by writeTextFile.
      destination = "/etc/alacritty.yaml";
      # NOTE: YAML has been a strict superset of JSON since 1.2.
      text = lib.replaceStrings ["\\\\"] ["\\"] (builtins.toJSON cfg);
    };
    
    customizedAlacritty = pkgs.symlinkJoin {
      name = "alacritty-bds";
      paths = [ config-file pkgs.alacritty ];
      buildInputs = [ pkgs.alacritty pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/alacritty \
          --add-flags --config-file=${config-file}/etc/alacritty.yaml
      '';
    };

in {
  environment.systemPackages = [ customizedAlacritty ];
}

