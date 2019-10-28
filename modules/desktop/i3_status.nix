{ lib, pkgs, ... }:

{
  environment.etc."i3/statusbar.toml" = {
    text = ''
      theme = "slick"
      icons = "awesome"
      
      [[block]]
      block = "disk_space"
      path = "/home"
      alias = "Home"
      info_type = "available"
      unit = "GB"
      interval = 20
      warning = 20.0
      alert = 10.0
      
      [[block]]
      block = "memory"
      display_type = "memory"
      format_mem = "{Mup}%"
      format_swap = "{SUp}%"
      
      [[block]]
      block = "cpu"
      interval = 1
      
      [[block]]
      block = "sound"
          
      [[block]]
      block = "time"
      interval = 60
      format = "%a %d/%m %R"
    '';
  };
}
