{ config, pkgs, lib, ... }:

{
  imports = (
    lib.optional (builtins.pathExists ./local.nix) ./local.nix
  );

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jluttine";
  home.homeDirectory = "/home/jluttine";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    vim
    coreutils
    findutils
    diffutils
    gnutar
    xz
    bzip2
    unzip
    zip
    patch
    file
    jq
    tree
    xxd
    hexdump
    sqlite
    shellcheck
    binutils
    gnugrep
    gnused
    gawk
    git
    pijul
    yadm
    gnupg
    pinentry-curses
    ripgrep
    curl
    croc
    eca
    gzip
    procps
    which
    man
    less
    opencode
    opencode-desktop
    # emacs-pgtk is the Wayland-native Emacs
    emacs-pgtk
    python3
    chromium

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jluttine/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export VISUAL=vim
      export EDITOR=vim
      export PATH="$HOME/.emacs.d/bin:$PATH"
    '';
    profileExtra = ''
      umask 077
      # set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/.local/bin" ] ; then
          PATH="$HOME/.local/bin:$PATH"
      fi
      # if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] ; then
      #     . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      # fi
    '';
    shellAliases = {
      "yadm-nixos" = "yadm --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data";
      ls = "ls --color=auto";
      ll = "ls -lh";
      la = "ls -a";
      lla = "ls -lha";
      df = "df -h";

      # Interactivity
      rm = "rm -I";
      cp = "cp -i";
      mv = "mv -i";

      # zipping and stuff
      mktar = "tar -cvf";
      mkbz2 = "tar -cvjf";
      mkgz = "tar -cvzf";
      untar = "tar -xvf";
      unbz2 = "tar -xvjf";
      ungz = "tar -xvzf";

      # Directory navigation
      home = "cd ~";
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      base16-nvim
      vim-nix
    ];
    # Load Noctalia theme file that Noctalia generates automatically
    initLua = ''
      local ok, matugen = pcall(require, 'matugen')
      if ok then matugen.setup() end
    '';
  };

}
