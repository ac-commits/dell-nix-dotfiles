#!/usr/bin/env sh

nix-channel --add https://github.com/nix-community/home-manager/archive/release-$0.tar.gz home-manager
nix-channel --update && nix-shell '<home-manager>' -A install
exit 0
