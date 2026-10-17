# from nixos-generate-config on mimosa
{
  flake.modules.nixos.mimosa-hardware =
    { lib, modulesPath, ... }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot = {
        initrd.availableKernelModules = [
          "xhci_pci_renesas"
          "mpt3sas"
          "nvme"
          "usb_storage"
          "usbhid"
        ];
        initrd.kernelModules = [ ];
        kernelModules = [ ];
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/5522a903-22a2-408e-8a3e-8639f59540cd";
        fsType = "btrfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/561B-340A";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
