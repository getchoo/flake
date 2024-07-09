{ config, lib, ... }:
{
  options.base.defaultPrograms = {
    enable = lib.mkEnableOption "default programs" // {
      default = config.base.enable;
      defaultText = lib.literalExpression "config.base.enable";
    };
  };
}
