#!/bin/sh
# installs the latest release for the current OS/arch. no Go required.
# usage: curl -fsSL https://raw.githubusercontent.com/sahithyandev/go-cli-template/main/scripts/install.sh | sh
#
# rename the repo and binary variables below when adapting this template.
set -eu

repo="sahithyandev/go-cli-template"
binary="app"

os=$(uname -s)
case "$os" in
	Linux) os=linux ;;
	Darwin) os=darwin ;;
	*)
		echo "unsupported OS: $os ($binary ships Linux and macOS binaries; Windows users run scripts/install.ps1)" >&2
		exit 1
		;;
esac

arch=$(uname -m)
case "$arch" in
	x86_64 | amd64) arch=amd64 ;;
	arm64 | aarch64) arch=arm64 ;;
	*)
		echo "unsupported architecture: $arch" >&2
		exit 1
		;;
esac

tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" |
	grep -m1 '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
version=${tag#v}

if installed=$("$binary" version 2>/dev/null); then
	if [ "$installed" = "$version" ]; then
		echo "$binary $version is already up to date"
		exit 0
	fi
	echo "updating $binary $installed -> $version"
fi

archive="${binary}_${version}_${os}_${arch}.tar.gz"
url="https://github.com/$repo/releases/download/$tag/$archive"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "downloading $url"
curl -fsSL "$url" -o "$tmpdir/$archive"
tar -xzf "$tmpdir/$archive" -C "$tmpdir"

bindir="/usr/local/bin"
if [ ! -w "$bindir" ]; then
	bindir="$HOME/.local/bin"
	mkdir -p "$bindir"
fi

mv "$tmpdir/$binary" "$bindir/$binary"
chmod +x "$bindir/$binary"
echo "installed $binary $version to $bindir/$binary"

case ":$PATH:" in
	*":$bindir:"*) ;;
	*) echo "add $bindir to your PATH to run '$binary' directly" ;;
esac

# zsh completion: save the script once and source it from ~/.zshrc
case "${SHELL:-}" in
	*/zsh)
		mkdir -p "$HOME/.$binary"
		"$bindir/$binary" completion zsh >"$HOME/.$binary/_$binary"
		line="[ -s ~/.$binary/_$binary ] && source ~/.$binary/_$binary"
		if ! grep -qsF "$line" "$HOME/.zshrc"; then
			echo "$line" >>"$HOME/.zshrc"
		fi
		echo "zsh completion installed, open a new terminal to use it"
		;;
esac
