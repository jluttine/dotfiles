# See:
# https://github.com/NixOS/nixpkgs/commit/c4018c0e65f825584f6154fd91b85d7ad6fe9896
#
# GnuPG 2.1.x changed the way the gpg-agent works, and that new approach no
# longer requires (or even supports) the "start everything as a child of the
# agent" scheme we've implemented in NixOS for older versions.
#
# To configure the gpg-agent for your X session, add the following code to
# ~/.xsession or some other appropriate place that's sourced at start-up:

gpg-connect-agent /bye
GPG_TTY=$(tty)
export GPG_TTY

