#!/bin/sh

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FULL_NAME=$(git config -f "${HOME}/.gitconfig-local" user.name)
if [ -z "${FULL_NAME}" ]; then
	read -p "What is your full name? " FULL_NAME
	git config -f "${HOME}/.gitconfig-local" user.name "${FULL_NAME}"
fi

DEFAULT_EMAIL=$(git config -f "${HOME}/.gitconfig-local" user.email)
if [ -z "${DEFAULT_EMAIL}" ]; then
	read -p "What is your email address? " DEFAULT_EMAIL
	git config -f "${HOME}/.gitconfig-local" user.email ${DEFAULT_EMAIL}
fi

if [ -z "${HOMEBREW_GITHUB_API_TOKEN}" ]; then
	read -n 1 -s -r -p "Press any key to open your GitHub tokens settings page; be sure not to select any scopes."
	echo ""
	open "https://github.com/settings/tokens"
	read -p "Enter your homebrew GitHub API token: " HOMEBREW_GITHUB_API_TOKEN
	export HOMEBREW_GITHUB_API_TOKEN
	if [ ! -z "${HOMEBREW_GITHUB_API_TOKEN}" ]; then
		echo "-- Writing API token to ~/.bashrc-local"
		echo "export HOMEBREW_GITHUB_API_TOKEN=${HOMEBREW_GITHUB_API_TOKEN}" >> ~/.bashrc-local
	fi
fi

if ! xcode-select -p >/dev/null; then
	echo "-- Installing Xcode command line tools"
	xcode-select --install
fi

if ! command -v brew >/dev/null 2>&1; then
	echo "-- Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "-- Updating homebrew"
brew update

echo "-- Checking homebrew installation"
brew doctor

if [ -f "${BASEDIR}/brew-packages" ]; then
	echo "-- Installing/upgrading brew packages"
	INSTALLED_BREW_PKGS=$(brew list -1)
	OUTDATED_BREW_PKGS=$(brew outdated)
	while read -u 10 p; do
		if ! echo "${INSTALLED_BREW_PKGS}" | grep -q "^${p}\$"; then
			brew install ${p}
		elif echo "${OUTDATED_BREW_PKGS}" | grep -q "^${p}\$"; then
			brew upgrade ${p}
		fi
	done 10<"${BASEDIR}/brew-packages"
fi

if ! command -v git-lfs >/dev/null 2>&1; then
	git lfs install
fi
