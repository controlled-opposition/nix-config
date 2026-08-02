{
  programs.emacs.enable = true;

  home.file.".emacs.d/init.el" = {
    source = ./init.el;
    force = true;
  };
}
