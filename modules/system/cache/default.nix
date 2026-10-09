{
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://invra.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "invra.cachix.org-1:5lB/b5n5iQVLCbAYfnH5f5ASzqlVB6uKfINHge7lVvk="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}
