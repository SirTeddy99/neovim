# Neovim Setup Makefile
# Usage:
#   make install    - Full setup (deps + neovim + config)
#   make deps       - Install dependencies only
#   make neovim     - Build and install Neovim only
#   make config     - Clone config only
#   make update     - Update Neovim to latest stable
#   make clean      - Remove build artifacts
#   make uninstall  - Remove Neovim (keeps config)

.PHONY: install deps neovim config update clean uninstall help

# Default target
install: deps neovim config
	@echo ""
	@echo "🎉 Setup complete!"
	@echo ""
	@nvim --version | head -n 1
	@echo ""
	@echo "Run 'nvim' to start Neovim"

# Install all dependencies
deps:
	@echo "📦 Installing dependencies..."
	@sudo apt update
	@sudo apt install -y \
		git \
		gcc \
		clang \
		build-essential \
		ninja-build \
		gettext \
		cmake \
		unzip \
		curl \
		make \
		ripgrep \
		fd-find \
		lua5.1 \
		luarocks \
		libreadline-dev \
		libncurses5-dev \
		libncursesw5-dev
	@echo "✅ Dependencies installed"

# Build and install Neovim from source
neovim:
	@echo "🔨 Building Neovim from source..."
	@if [ -d ~/neovim ]; then \
		echo "Removing old neovim directory..."; \
		rm -rf ~/neovim; \
	fi
	@cd ~ && git clone https://github.com/neovim/neovim.git
	@cd ~/neovim && git checkout stable
	@echo "Compiling Neovim (this takes a few minutes)..."
	@cd ~/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
	@echo "Installing Neovim..."
	@cd ~/neovim && sudo make install
	@hash -r
	@echo "✅ Neovim installed"

# Clone Neovim config
config:
	@echo "📁 Setting up Neovim config..."
	@if [ -d ~/.config/nvim ]; then \
		backup_name="nvim.backup.$(date +%Y%m%d-%H%M%S)"; \
		echo "Backing up existing config to ~/.config/$backup_name"; \
		mv ~/.config/nvim ~/.config/$backup_name; \
	fi
	@mkdir -p ~/.config
	@cd ~/.config && git clone https://github.com/SirTeddy99/neovim.git
	@cd ~/.config && mv neovim nvim
	@echo "✅ Config cloned and renamed to nvim"

# Update Neovim to latest stable
update:
	@echo "🔄 Updating Neovim..."
	@if [ ! -d ~/neovim ]; then \
		echo "Neovim source not found. Run 'make neovim' first."; \
		exit 1; \
	fi
	@cd ~/neovim && git fetch && git checkout stable && git pull
	@cd ~/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
	@cd ~/neovim && sudo make install
	@hash -r
	@echo "✅ Neovim updated"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@if [ -d ~/neovim ]; then \
		cd ~/neovim && make clean; \
		echo "✅ Build artifacts cleaned"; \
	else \
		echo "No neovim directory found"; \
	fi

# Uninstall Neovim (keeps config)
uninstall:
	@echo "🗑️  Uninstalling Neovim..."
	@if [ -d ~/neovim ]; then \
		cd ~/neovim && sudo make uninstall; \
	fi
	@sudo rm -f /usr/local/bin/nvim
	@echo "✅ Neovim uninstalled (config preserved)"

# Show help
help:
	@echo "Neovim Setup Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install    - Full setup (deps + neovim + config)"
	@echo "  make deps       - Install dependencies only"
	@echo "  make neovim     - Build and install Neovim only"
	@echo "  make config     - Clone config only"
	@echo "  make update     - Update Neovim to latest stable"
	@echo "  make clean      - Remove build artifacts"
	@echo "  make uninstall  - Remove Neovim (keeps config)"
	@echo "  make help       - Show this help message"
