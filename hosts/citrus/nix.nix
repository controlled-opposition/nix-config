{
  nix.settings = {
    auto-optimise-store = true;

    fallback = true;

    extra-substituters = [
      "https://cache.lantian.pub/lantian"
      "https://nix-community.cachix.org"
      "https://invra.cachix.org"
      "https://wvhulle.cachix.org"
    ];

    extra-trusted-public-keys = [
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "invra.cachix.org-1:5lB/b5n5iQVLCbAYfnH5f5ASzqlVB6uKfINHge7lVvk="
      "wvhulle.cachix.org-1:heXx8DZMiRsKUx6l1TxNoF+Nmtmz66QEdsonQzc1ir0="
    ];
  };
}
