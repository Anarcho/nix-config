{
  config,
  lib,
  colors,
  ...
}: let
  inherit (colors) base extended;
in {
  style = ''
    * {
      font-family: JetBrainsMono Nerd Font, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
      font-size: 14px;
      font-weight: bold;
    }

    window#waybar {
      background-color: ${extended.background.rgba};
      color: ${base."05"}; # Using base05 for main text
      transition-property: background-color;
      transition-duration: .5s;
    }

    button {
      all: unset;
      background-color: ${extended.button.normal};
      color: ${extended.button.foreground};
      border-bottom: 8px solid ${extended.button.bottom};
      border-radius: 5px;
      margin: 4px 6px;
      padding: 6px 17px;
    }

    button:hover {
      background-color: ${extended.button.hover};
    }

    button.active {
      background-color: ${extended.button.active};
    }

    #custom-powermenu {
      background-color: ${extended.power.button};
      border-bottom: 8px solid ${extended.power.button_bottom};
    }

    #clock {
      background-color: ${base."0B"}; # Green
      border-bottom: 8px solid ${base."0B"};
    }

    #memory {
      background-color: ${base."0E"}; # Purple
      border-bottom: 8px solid ${base."0E"};
    }

    #cpu {
      background-color: ${base."0A"}; # Yellow
      border-bottom: 8px solid ${base."0A"};
    }
  '';
}
