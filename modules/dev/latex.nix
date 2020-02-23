{ config, lib, pkgs, ... }:

let breakds-texlive = with pkgs; texlive.combine {
      inherit (texlive) collection-basic collection-latex collection-fontsrecommended
        collection-langchinese collection-langcjk collection-metapost;
    };

in {
  environment.systemPackages = with pkgs; [
    breakds-texlive
  ];
}
