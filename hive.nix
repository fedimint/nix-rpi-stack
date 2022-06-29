{
  meta = {
    nixpkgs = <nixpkgs>;
  };

  defaults = { pkgs, modulesPath, lib, name, ... }: {
    nixpkgs.system = "aarch64-linux";
    deployment = {
      buildOnTarget = true;
      targetUser = "user";
      replaceUnknownProfiles = true;
      targetHost = "rpi-" + name;
    };

    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot = {
      initrd = {
        availableKernelModules = [ "xhci_pci" ];
        kernelModules = [ ];
      };
      kernelModules = [ ];
      extraModulePackages = [ ];

      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
    };

    fileSystems."/" =
      { device = "/dev/mmcblk1p2";
        fsType = "ext4";
      };

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = "ondemand";

    networking = {
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
      hostName = name;
    };

    time.timeZone = "UTC";
    i18n.defaultLocale = "en_US.UTF-8";

    environment.systemPackages = with pkgs; [
      vim wget curl htop tmux nload
    ];

    services.openssh.enable = true;

    users = {
      mutableUsers = false;
      users.user = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ./pikey.pub) ];
      };
    };

    nix.trustedUsers = [ "root" "@wheel" ];
    security.sudo.wheelNeedsPassword = false;

    system = {
      copySystemConfiguration = true;
      stateVersion = "22.05";
    };
  };

  node-1 = { ... }: {
    networking.interfaces.eth0.ipv4.addresses = [ {
      address = "10.42.0.11";
      prefixLength = 24;
    } ];
  };

  node-2 = { ... }: {
    networking.interfaces.eth0.ipv4.addresses = [ {
      address = "10.42.0.12";
      prefixLength = 24;
    } ];
  };

  node-3 = { ... }: {
    networking.interfaces.eth0.ipv4.addresses = [ {
      address = "10.42.0.13";
      prefixLength = 24;
    } ];
  };

  node-4 = { ... }: {
    networking.interfaces.eth0.ipv4.addresses = [ {
      address = "10.42.0.14";
      prefixLength = 24;
    } ];
  };
}