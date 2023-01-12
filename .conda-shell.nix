let

  #pinnedPkgs = import (
  #  builtins.fetchTarball {
  #    # Descriptive name to make the store path easier to identify
  #    name = "nixos-unstable-2019-02-11";
  #    # Commit hash for nixos-unstable as of 2019-02-11
  #    url = https://github.com/nixos/nixpkgs/archive/36f316007494c388df1fec434c1e658542e3c3cc.tar.gz;
  #    # Hash obtained using `nix-prefetch-url --unpack <url>`
  #    sha256 = "1w1dg9ankgi59r2mh0jilccz5c4gv30a6q1k6kv2sn8vfjazwp9k";
  #  }
  #) {};

  hostPkgs = import <nixpkgs> {};

  #pkgs = pinnedPkgs;
  pkgs = hostPkgs;

  #installationPath = "~/.miniconda";
  installationPath = "~/.conda";

  minicondaScript = pkgs.stdenv.mkDerivation rec {
    name = "miniconda-${version}";
    version = "4.12.0";
    src = pkgs.fetchurl {
      url = "https://repo.continuum.io/miniconda/Miniconda3-py39_${version}-Linux-x86_64.sh";
      sha256 = "sha256-ePOfm66XHsGueWnwUWAX8kE/F3lmcPcEByXdg/z/Vok=";
    };
    # Nothing to unpack.
    unpackPhase = "true";
    # Rename the file so it's easier to use. The file needs to have .sh ending
    # because the installation script does some checks based on that assumption.
    # However, don't add it under $out/bin/ becase we don't really want to use
    # it within our environment. It is called by "conda-install" defined below.
    installPhase = ''
      mkdir -p $out
      cp $src $out/miniconda.sh
    '';
    # Add executable mode here after the fixup phase so that no patching will be
    # done by nix because we want to use this miniconda installer in the FHS
    # user env.
    fixupPhase = ''
      chmod +x $out/miniconda.sh
    '';
  };

  # Wrap miniconda installer so that it is non-interactive and installs into the
  # path specified by installationPath
  myconda = let
    libPath = with pkgs; lib.makeLibraryPath [
      zlib # libz.so.1
    ];
  in pkgs.runCommand "conda-install"
    { buildInputs = [ pkgs.makeWrapper minicondaScript ]; }
    ''
      mkdir -p $out/bin
      makeWrapper                             \
        ${minicondaScript}/miniconda.sh       \
        $out/bin/conda-install                \
        --add-flags "-p ${installationPath}"  \
        --add-flags "-b"                      \
        --prefix "LD_LIBRARY_PATH" : "${libPath}"
    '';

in
(
  pkgs.buildFHSUserEnv {
    name = "conda";
    targetPkgs = pkgs: (
      with pkgs; [

        myconda
        zlib

        # These are related to matplotlib PyQt5. Fix the following error:
	# This application failed to start because it could not find or load
	# the Qt platform plugin "xcb" in "".
	xorg.libX11
	xorg.libXi

        # Missing libraries for IPython. Find these using:
        # LD_DEBUG=libs ipython --pylab
        xorg.libSM
        xorg.libICE
        xorg.libXrender
        xorg.libxcb
        libGL

        # For Spyder
        #libselinux

        # Just in case one installs a package with pip instead of conda and pip
        # needs to compile some C sources
        gcc

        # These are just my own personal requirements. If Emacs could seamlessly
        # activate nix-shells per project, these would be mostly unnecessary.
        emacs
        xclip

        which

        gnumake
        gnupg1orig
        ksshaskpass

        # importmagic.el requires this importmagic but install it via conda
        # (python.withPackages (
        #   ps: with ps; [
        #     importmagic
        #   ]
        # ))

        git
        gitAndTools.gitflow
        #nbstripout

        # PDF exports in Jupyter notebooks
        #texlive.combined.scheme-full
        #inkscape
        #pdf2svg

        # Library for Jupyter notebook extensions
        icu58
        glibcLocales

      ]
    );
    profile = ''
      # Add conda to PATH
      export PATH=${installationPath}/bin:$PATH
      # Paths for gcc if compiling some C sources with pip
      export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
      export NIX_CFLAGS_LINK="-L${installationPath}lib"

      # Fonts (at least Spyder requires?)
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale

      # Fix error "Qt: Failed to create XKB context!"
      export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"

      # This is just my personal setting for using GPG agent within the environment too
      export GPG_AGENT_INFO=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent:0:1
    '';
  }
).env
