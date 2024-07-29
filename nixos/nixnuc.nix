# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./nixnuc-hardware.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixnuc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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
  services.xserver = {
    enable = true;

    excludePackages = with pkgs; [
      xterm
    ];

    displayManager = {
      lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
          theme.name = "Zukitre-dark";
        };
      };
      sessionCommands = "test -f ~/.xinitrc && . ~/.xinitrc";
    };

    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.displayManager.defaultSession = "xfce";



  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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


  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    users = {
      vetsin = {
        isNormalUser = true;
        description = "vetsin";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
          alacritty
          vimpager
          fzf
          silver-searcher
          discord
          _1password-gui
          _1password
        ];
        shell = pkgs.zsh;
      };
    };
  };

  hardware.gpgSmartcards.enable = true;

  programs = {

    firefox.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "philips";
        plugins = [ "vi-mode" "fzf" ];
      };
    };

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "vetsin" ];
    };

    ssh = {
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };

    git = {
      enable = true;
      config = {
        user.name = "vetsin";
        user.email = "131726+vetsin@users.noreply.github.com";
        user.signingkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZ6gjBhr+Gq5hw0N1LMOcMELxpnE2cDssluYqd8aqQlOxEzkf/bWVBBfCT9baoPllXLWodq/pXwXxMpDn4cSuXraUkdmfFzOL0rb2gX45NTqMNHopn/zVu63wp0aAyZfahv0qa8+wF9dSQL5o6c7ddsRq84BJA1l6jfJLWZG6PR5CgUq2X9HjUtGVIuBsEiiDeBEyp4TpWwz+NIGxLRZynN5iALej2tM+aEW1jrBD/h7YHu+0nPI0KbxodAHvdl5lBhkaRojW+qhIP4SjNlrgLMIaWu3MANat9nBN08DgWXed1A0vVJ8jk2feZ6vuITeGHxxsZeTuU+WmH8iu7Jbox";
        gpg.format = "ssh";
        gpg = { "ssh" = { program = "${pkgs._1password-gui.out}/bin/op-ssh-sign"; }; };
        commit.gpgsign = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim-full
    wget
    curl
    git
    file
    elementary-xfce-icon-theme
    font-manager
    pavucontrol
    xclip
    xcolor
    wmctrl
    xfce.xfce4-appfinder
    xfce.xfce4-clipman-plugin
    xfce.xfce4-panel
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-systemload-plugin
    xfce.xfce4-xkb-plugin
    xorg.xev
    xtitle
    xsel
    zuki-themes
  ];

  environment = {
    etc = {
      "per-user/alacritty/alacritty.toml".text = import ./alacritty.nix { zsh = pkgs.zsh; };
    };
    sessionVariables = {
      TERMINAL = [ "alacritty" ];
      EDITOR = [ "vim" ];
    };
  };


  system.userActivationScripts = {
    extraUserActivation = {
      text = ''
        ln -sfn /etc/per-user/alacritty ~/.config
      '';
      deps = [];
    };
  };

  #services.openssh = {
  #  enable = true;
  #  settings = {
  #    PermitRootLogin = "no";
  #    PasswordAuthentication = false;
  #  };
  #};
  #services.yubikey-agent = {
  #  enable = true;
  #};

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
