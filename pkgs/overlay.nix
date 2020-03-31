self: super:

{
  ert-run = self.callPackage ./ert-run { };

  iosevkaBaba = (self.callPackage ./iosevka { }) "Iosevka Baba" "baba" true;
  iosevkaTermBaba =
    (self.callPackage ./iosevka { }) "Iosevka Term Baba" "term-baba" false;

  juno = self.callPackage ./juno { src = self.sources.juno; };

  mutate = self.callPackage ./mutate { };

  nix-patch = self.callPackage ./nix-patch { };

  nixos-update = self.callPackage ./nixos-update { };

  prime = self.callPackage ./prime { };

  plymouth-themes =
    self.callPackage ./plymouth-themes { src = self.sources.plymouth-themes; };

  xterm-24bits = self.callPackage ./xterm-24bits { };
}
