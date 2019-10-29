{ config, lib, pkgs, ... }:

let battery = if config.bds.desktop.xserver.i3_show_battery then ''
      [[block]]
      block = "battery"
      interval = 10
      format = "{percentage}% {time}"
    '' else "";

in {
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

      ${battery}

      [[block]]
      block = "sound"
          
      [[block]]
      block = "time"
      interval = 60
      format = "%a %d/%m %R"
    '';
  };
}
