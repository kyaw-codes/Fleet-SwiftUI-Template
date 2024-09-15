.DEFAULT_GOAL := setup_local_environment

RUBY_VERSION := 2.7.7
ZSH_SHELL := /bin/zsh

# MARK: - Setup Environment Scripts

setup_local_environment: \
	check_for_homebrew \
	install_swiftlint \
	install_tuist \

# we don't need ruby for now
#	install_rbenv \
#	install_ruby \
#	install_bundler \


check_for_homebrew:
	$(info Checking for Homebrew 🍺 ...)
	@if command -v brew > /dev/null 2>&1; then \
		echo "Homebrew is installed ✅."; \
		echo "Homebrew version: $$(brew --version | head -n 1)"; \
	else \
		echo "Homebrew is not installed 😔. Installing now..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "Homebrew installation complete."; \
	fi

install_rbenv:
	@which rbenv > /dev/null 2>&1 || { \
		echo "rbenv is not installed 😔. Installing now..."; \
		brew install rbenv; \
		echo "rbenv installation complete ✅."; \
	}
	@which rbenv > /dev/null 2>&1 && echo "rbenv is already installed ✅."

install_ruby:
	$(info Checking if Ruby $(RUBY_VERSION) is already installed ...)
	@if rbenv versions | grep -q "$(RUBY_VERSION)"; then \
		echo "Ruby $(RUBY_VERSION) is already installed ✅."; \
	else \
		echo "Installing Ruby $(RUBY_VERSION) ..."; \
		rbenv install $(RUBY_VERSION); \
	fi
	$(info Setting Ruby $(RUBY_VERSION) as global version ✅...)
	rbenv global $(RUBY_VERSION)

install_bundler:
	$(info Installing Bundler...)
	@if ! gem list bundler -i > /dev/null; then \
		gem install bundler; \
		rbenv rehash; \
		echo "Bundler installed."; \
	else \
		echo "Bundler is already installed."; \
	fi

install_swiftlint:
	@which swiftlint > /dev/null 2>&1 || { \
		echo "SwiftLint is not installed 😔. Installing now..."; \
		brew install swiftlint; \
		echo "SwiftLint installation complete ✅."; \
	}
	@which swiftlint > /dev/null 2>&1 && echo "SwiftLint is already installed ✅."

check_mise_and_install:
	@if which mise > /dev/null 2>&1; then \
		echo "mise is installed ✅."; \
	else \
		echo "mise is not installed 😔. Installing now..."; \
		curl https://mise.run | sh; \
		echo "mise installation complete."; \
		echo "Adding mise to your shell..."; \
		MISE_PATH=$$(which mise); \
		echo 'eval "$$($$MISE_PATH activate zsh)"' >> $$HOME/.zshrc; \
		source $$HOME/.zshrc; \
	fi

install_tuist: check_mise_and_install
	@if which mise > /dev/null 2>&1; then \
		echo "Tuist is installed ✅."; \
	else \
		mise install tuist; \
		echo "Tuist installation complete ✅."; \
		mise use tuist@latest; \
	fi
