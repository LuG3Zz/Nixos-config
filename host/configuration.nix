# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib,... }:
let
   user = "brownlu";

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
 # boot.loader.systemd-boot.enable = true;
 boot.loader = {
    efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi"; # 默认是 /boot，重点就是改这里

    };

    grub = {
      enable = true;
      device = "nodev";
      default = "1"; # 选择第二个引导项，从0开始计数
      efiSupport = true;
      useOSProber = true;
    };
  };

boot = {
kernelPackages = pkgs.linuxPackages_latest;
supportedFilesystems = [ "ntfs" ];
};

swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];

   networking.hostName = "BrownLu"; # Define your hostname.
  # Pick only one of the below networking options.
   #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
    i18n.defaultLocale = "zh_CN.UTF-8"; 
   console = {
     font = "jetbrains-mono";
     #keyMap = "us";
     #useXkbConfig = true; # use xkbOptions in tty.
   };

i18n.inputMethod = {
  enabled = "ibus";
   ibus.engines = with pkgs.ibus-engines; [
     libpinyin
   ];
};

# 中文字体
fonts = {
  fonts = with pkgs; [
   (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
     sarasa-gothic  #更纱黑体 
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    hack-font
    jetbrains-mono
  ];
};


  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound={
   	enable = true;
	mediaKeys.enable =true;
   };
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.${user} = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
     packages = with pkgs; [
       firefox
       tree
       microsoft-edge
     ];
   };
   programs.zsh.enable = true;
  # List packages installed in system profile. To search, run:ryan
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     git
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     neofetch
     wget
     neovim
      (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config
                                                    pkgs.ncurses
                                                    pkgs.fuse
                                                    ];
      profile = "export FHS=1";
      runScript = "zsh";
      extraOutputsToInstall = ["dev"];
    }))
   ];

   nixpkgs.config.allowUnfree = true;
   programs.neovim.withPython3 = true;


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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

   nix = {
   settings={
   	experimental-features = ["nix-command""flakes"];
   	#substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
	auto-optimise-store = true;
   };
   gc = {
	automatic = true;
	dates = "weekly";
	options = "--delete-older-than 7d";
   	};
   };
  

}

