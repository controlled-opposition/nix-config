{
  nix.settings = {
    auto-optimise-store = true;

    fallback = true;

    substituters = [ "https://cache.lantian.pub/lantian" ];
    trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://invra.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "invra.cachix.org-1:5lB/b5n5iQVLCbAYfnH5f5ASzqlVB6uKfINHge7lVvk="
    ];
  };
}
