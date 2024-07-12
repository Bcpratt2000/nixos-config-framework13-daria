# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

#allow installing packages from unstable using unstable.<package>
let
#  unstable = import <unstable> {config = {allowUnfree = true; }; };
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/nixos-unstable)
    {config = config.nixpkgs.config; };
in {
    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
      ];

    # system.fsPackages = [ pkgs.cifs-utils ];
    # fileSystems."/home/ben/BENVER" = {
    #     device = "//192.168.54.11/ben";
    #     fsType = "cifs";
    #     options = let
    #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0770,dir_mode=0770,gid=100,uid=1000";
  
    #     in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
    # };
    # fileSystems."/home/ben/BENVER-MEDIA" = {
    #     device = "//192.168.54.11/media";
    #     fsType = "cifs";
    #     options = let
    #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0770,dir_mode=0770,gid=100,uid=1000";
  
    #     in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
    # };
  
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  
    networking.hostName = "Daria-Framework"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
    # Enable networking
    networking.networkmanager.enable = true;

    #enable tailscale
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "both";
  
  
    # Set your time zone.
    time.timeZone = "America/Denver";
  
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
  
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  
    # Enable the X11 windowing system.
    services.xserver.enable = true;
  
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  
    # Configure keymap in X11
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
  
    # Enable CUPS to print documents.
    services.printing.enable = true;
  
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    
    #fix for bottles package not functioning https://github.com/NixOS/nixpkgs/issues/270565
    programs.dconf.enable = true;
  
    #enable rtl-sdr support
    hardware.rtl-sdr.enable = true;
    users.groups.plugdev = {};
    
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.daria = {
      isNormalUser = true;
      description = "Daria Pratt";
      initialPassword="password";
      extraGroups = [ "networkmanager" "wheel" "dialout" "adbusers" "plugdev" "vboxusers"];
      uid = 1001;
    };
    users.users.ben = {
      isNormalUser = true;
      description = "Ben Pratt";
      initialPassword="password";
      extraGroups = [ "networkmanager" "wheel" "dialout" "adbusers" "plugdev" "vboxusers"];
      uid = 1000;
    };

    users.groups.users.gid = 100;

    programs.adb.enable = true;
  
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    #virtualbox	
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;

    #
    services.onedrive.enable = true;
  
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];
    environment.systemPackages = with pkgs; [
      audacity
      btop
      unstable.discord
      firefox
      git
      glances
      htop
      iperf
      nmap
      keepassxc
      libreoffice
      neovim
      obs-studio
      rdesktop
      screen
      signal-desktop
      speedtest-cli
      spotify
      sshfs
      steam
      tailscale
      thunderbird
      vim
      vlc
      vulkan-tools
      #vscode
      wget
      xclip
    ];
  
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  
    # List services that you want to enable:
  
    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;
  
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

}
