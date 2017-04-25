# See:
# https://github.com/NixOS/nixpkgs/commit/c4018c0e65f825584f6154fd91b85d7ad6fe9896
#
# GnuPG 2.1.x changed the way the gpg-agent works, and that new approach no
# longer requires (or even supports) the "start everything as a child of the
# agent" scheme we've implemented in NixOS for older versions.

export GPG_AGENT_INFO=${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent:0:1
