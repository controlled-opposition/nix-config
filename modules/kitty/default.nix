{ ... }:
{
  files.".config/kitty/kitty.conf" = {
    source = ./kitty.conf;
    clobber = true;
  };

}
