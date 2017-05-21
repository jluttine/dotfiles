{ pkgs ? import <nixpkgs> {} }:

let

  scriptName = "miniconda-install.sh";

  installationPath = "$HOME/.miniconda";

  miniconda = pkgs.stdenv.mkDerivation rec {
    name = "miniconda-${version}";
    version = "4.3.11";
    src = pkgs.fetchurl {
      url = "https://repo.continuum.io/miniconda/Miniconda3-${version}-Linux-x86_64.sh";
      sha256 = "1f2g8x1nh8xwcdh09xcra8vd15xqb5crjmpvmc2xza3ggg771zmr";
    };
    # Nothing to unpack.
    unpackPhase = "true";
    # Rename the file so it's easier to use. The file needs to have .sh ending
    # because the installation script does some checks based on that
    # assumption. However, don't add it under $out/bin/ becase we don't really
    # want to use it within our environment.
    installPhase = ''
      mkdir -p $out
      cp $src $out/${scriptName}
    '';
    # Add executable mode here so that no patching will be done by nix.
    fixupPhase = ''
      chmod +x $out/${scriptName}
    '';
  };

#  nbstripout = pkgs.python35Packages.buildPythonPackage rec {
#    name = "${pname}-${version}";
#    version = "0.3.0";
#    pname = "nbstripout";
#    src = pkgs.python35Packages.fetchPypi {
#      inherit pname version;
#      sha256 = "126xhjma4a0k7gq58hbqglhb3rai0a576azz7g8gmqjr3kl0264v";
#    };
#  };

#  conda-installer = pkgs.runCommand "conda-install-script"
#    { buildInputs = [ pkgs.makeWrapper conda-installer-package ]; }
#    ''
#      mkdir -p $out/bin
#      makeWrapper                                   \
#        ${conda-installer-package}/conda-install.sh \
#        $out/bin/conda-install                      \
#        --add-flags "-p ${conda-path}"              \
#        --add-flags "-b"
#    '';

in
(
  pkgs.buildFHSUserEnv {
    name = "conda";
    targetPkgs = pkgs: (
      with pkgs; [

        miniconda

        # Required at least to get libGL for matplotlib PyQt5
        #mesa

	# Missing libraries for IPython. Find these using: `LD_DEBUG=libs
	# ipython`
        xorg.libSM
        xorg.libICE
        xorg.libXrender

	# Just in case one installs a package with pip instead of conda and pip
	# needs to compile some C sources
        gcc

	# These are just my own personal requirements. If Emacs could
	# seamlessly activate nix-shells per project, these would be mostly
	# unnecessary.
        emacs
        xclip

        which

        gnumake
        gnupg1orig

        git
        gitAndTools.gitflow
        nbstripout
        getopt
        python35Packages.ipython

      ]
    );
    profile = ''
      if [ ! -d "${installationPath}" ]; then
        # CAUTION: setting LD_LIBRARY_PATH (on Linux) or DYLD_LIBRARY_PATH (on Mac OS X) can interfere with this because the dynamic linker short-circuits link resolution by first looking at LD_LIBRARY_PATH.
        #export _LD_LIBRARY_PATH=$LD_LIBRARY_PATH
        #unset LD_LIBRARY_PATH
        ${miniconda}/${scriptName} -b -p ${installationPath}
        #export LD_LIBRARY_PATH=$_LD_LIBRARY_PATH
        #unset _LD_LIBRARY_PATH
      fi
      # Add conda to PATH
      export PATH=${installationPath}/bin:$PATH
      # Paths for finding relevant libraries
      #export LD_LIBRARY_PATH="${installationPath}/lib:$LD_LIBRARY_PATH"
      #export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${installationPath}/lib"
      # Fonts
      #export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      # Paths for gcc if compiling some C sources with pip
      export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
      export NIX_CFLAGS_LINK="-L${installationPath}lib"

      # This is just my personal setting for using GPG agent within the environment too
      export GPG_AGENT_INFO=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent:0:1
    '';
  }
).env
