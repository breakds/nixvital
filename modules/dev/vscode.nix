{ config, lib, pkgs, ... } :

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.47.2";
      sha256 = "04niirbkrzsm4wk22pr5dcfymnhqq4vn25xwkf5xvbpw32v1bpp3";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.47.2";
      sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    }
    {
      name = "file-icons";
      publisher = "file-icons";
      version = "1.0.20";
      sha256 = "19pkh36jxg9x42r1d9pv97iyzx5n2gky6adhp5a2lkwhabaggbhk";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "10.2.0";
      sha256 = "0qnq9lr4m0j0syaciyv0zbj8rwm45pshpkagpfbf4pqkscsf80nr";
    }
    {
      name = "path-intellisense";
      publisher = "christian-kohler";
      version = "1.4.2";
      sha256 = "0i2b896cnlk1d23w3jgy8wdqsww2lz201iym5c1rqbjzg1g3v3r4";
    }
    {
      name = "theme-dracula";
      publisher = "dracula-theme";
      version = "2.19.0";
      sha256 = "0lgf1a7a8ikvkas4g69w1n5i3s5pabs6d394na2nz0iib490kkw1";
    }
  ];
  
  customized-vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in {
  environment.systemPackages = [
    customized-vscode
  ];
}
