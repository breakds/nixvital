let pkgs = import <nixpkgs> {
      overlays = [
        (import ../../../overlays/ros)
      ];
    };
in pkgs.python_qt_binding
