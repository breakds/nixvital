let pkgs = import <nixpkgs> {
      overlays = [
        (import ../../../overlays/ros)
      ];
    };
in pkgs.rviz
