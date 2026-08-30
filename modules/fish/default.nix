{ ... }:
{
  files.".config/fish/config.fish" = {
    source = ./fish.config;
    clobber = true;
  };
}
