{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
  (
    final: prev:
    let
      finalAttrs = final.vmware-workstation;
      version = "17.6.1";
      build = "24319023";
      baseUrl = "https://web.archive.org/web/20241105192443if_/https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${version}/${build}/linux";
      vmware-unpack-env = prev.buildFHSEnv {
        pname = "vmware-unpack-env";
        inherit version;
        targetPkgs = pkgs: [ pkgs.zlib ];
      };
    in
    {
      vmware-workstation = prev.vmware-workstation.overrideAttrs {
        src =
          prev.fetchzip {
            url = "${baseUrl}/core/VMware-Workstation-${version}-${build}.x86_64.bundle.tar";
            hash = "sha256-VzfiIawBDz0f1w3eynivW41Pn4SqvYf/8o9q14hln4s=";
            stripRoot = false;
          }
          + "/VMware-Workstation-${version}-${build}.x86_64.bundle";
        unpackPhase = ''
          ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${finalAttrs.src} --extract unpacked"
        '';
      };
    }
  )
];
}
