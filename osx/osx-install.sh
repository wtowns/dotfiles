#!/bin/sh

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${HOMEBREW_GITHUB_API_TOKEN}" ]; then
	read -p "Enter your homebrew GitHub API token: " HOMEBREW_GITHUB_API_TOKEN
	export HOMEBREW_GITHUB_API_TOKEN
fi

if [ -z "${FULL_NAME}" ]; then
	read -p "What is your full name? " FULL_NAME
fi
if [ -z "${DEFAULT_EMAIL}" ]; then
	read -p "What is your email address? " DEFAULT_EMAIL
fi

if ! xcode-select -p >/dev/null; then
	echo "-- Installing Xcode command line tools"
	xcode-select --install
fi

if ! command -v brew >/dev/null 2>&1; then
	echo "-- Installing homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "-- Updating homebrew"
brew update

echo "-- Checking homebrew installation"
brew doctor

if [ -f "${BASEDIR}/brew-packages" ]; then
	echo "-- Installing/upgrading brew packages"
	INSTALLED_BREW_PKGS=$(brew list -1)
	OUTDATED_BREW_PKGS=$(brew outdated -1)
	while read -u 10 p; do
		if ! echo "${INSTALLED_BREW_PKGS}" | grep -q "^${p}\$"; then
			brew install ${p}
		elif echo "${OUTDATED_BREW_PKGS}" | grep -q "^${p}\$"; then
			brew upgrade ${p}
		fi
	done 10<"${BASEDIR}/brew-packages"
fi

if [ -f "${BASEDIR}/npm-packages" ]; then
	echo "-- Installing/upgrading npm packages; password may be required"
	INSTALLED_NPM_MODULES=$(npm ls -g --depth=0)
	OUTDATED_NPM_MODULES=$(npm outdated -g --depth=0)
	while read -u 30 p; do
		if ! echo "${INSTALLED_NPM_MODULES}" | grep -q " ${p}@"; then
			sudo npm install -g ${p}
		elif echo "${OUTDATED_NPM_MODULES}" | grep -q "^${p}\s"; then
			sudo npm update -g ${p}
		fi
	done 30<"${BASEDIR}/npm-packages"
fi

if [ ! -f "${HOME}/.gitconfig-local" ] || [ ! "$(git config -f "${HOME}/.gitconfig-local" user.name)" == "${FULL_NAME}" ] || [ ! "$(git config -f "${HOME}/.gitconfig-local" user.email)" == "${DEFAULT_EMAIL}" ]; then
	echo "-- Creating/updating .gitconfig-local"
	git config -f "${HOME}/.gitconfig-local" user.name "${FULL_NAME}"
	git config -f "${HOME}/.gitconfig-local" user.email ${DEFAULT_EMAIL}
fi

echo "-- Installing fonts"
cp "${BASEDIR}"/fonts/* "${HOME}/Library/Fonts/"

echo "-- Additional manual steps:"
echo "  * Set the iTerm2 preferences directory"
