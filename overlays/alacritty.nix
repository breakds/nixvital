{ stdenv, lib, basePackage, writeTextFile, makeWrapper, symlinkJoin, customize ? {} } :

let defaultConfig = {
      font-size = 10.0;
      font-face = "Monospace";
      history = 10000;
    };

    cfg = lib.recursiveUpdate defaultConfig customize;

    config-file = writeTextFile {
      name = "alacritty-config-file";
      executable = false;
      # Relative to the derivation created by writeTextFile.
      destination = "/etc/alacritty.yaml";
      text = ''
        window:
          decorations: full
        scrolling:
          # Maximum number of lines in the scrollback buffer.
          # Specify 0 will disable scrolling
          history: ${toString cfg.history}
        
        # Display tabs using this many cells
        tabspaces: 4
        
        # Font configuration
        font:
          normal:
            family: ${cfg.font-face}
          bold:
            family: ${cfg.font-face}
          italic:
            family: ${cfg.font-face}
        
          size: ${toString cfg.font-size}
        
          # Offset is the extra space around each character.
          # offset.y = line spacing
          # offset.x = letter spacing
          offset:
            x: 0
            y: 0
        
        cursor:
          style: HollowBlock
        
        # The Color Theme for Alacritty
        colors:
          primary:
            background: '0x434343'
            foreground: '0xececec'
          normal:
            black:   '0x000000'
            red:     '0xc62828'
            green:   '0x558b2f'
            yellow:  '0xf9a825'
            blue:    '0x1565c0'
            magenta: '0x6a1e9a'
            cyan:    '0x00838f'
            white:   '0xf2f2f2'
      '';
    };
in symlinkJoin {
  name = "alacritty-bds";
  paths = [ config-file basePackage ];
  buildInputs = [ basePackage makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/alacritty \
      --add-flags --config-file=${config-file}/etc/alacritty.yaml
  '';
}
