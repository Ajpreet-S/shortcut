#!/bin/bash
# Installer for shortcut - manage custom command shortcuts
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_URL="https://raw.githubusercontent.com/Ajpreet-S/shortcut/main/shortcut.sh"

print_success() { echo -e "\033[0;32m✓\033[0m $1"; }
print_error() { echo -e "\033[0;31m✗\033[0m $1"; }
print_info() { echo -e "\033[1;33m→\033[0m $1"; }

find_installation() {
    for dir in "$HOME/.local/bin" "$HOME/bin" "/usr/local/bin"; do
        [[ -f "$dir/shortcut" ]] && echo "$dir/shortcut" && return 0
    done
    return 1
}

install_file() {
    local src=$1 dest=$2
    if cp "$src" "$dest" 2>/dev/null && chmod +x "$dest" 2>/dev/null; then
        return 0
    elif sudo cp "$src" "$dest" 2>/dev/null && sudo chmod +x "$dest" 2>/dev/null; then
        print_info "Required sudo for installation"
        return 0
    fi
    return 1
}

uninstall() {
    print_info "Starting uninstall..."

    local path=$(find_installation)
    [[ -z "$path" ]] && print_error "Not installed" && exit 1

    print_info "Found at: $path"

    if rm "$path" 2>/dev/null || sudo rm "$path" 2>/dev/null; then
        print_success "Removed $path"
    else
        print_error "Failed to remove $path" && exit 1
    fi

    local config="$HOME/.config/shortcut"
    if [[ -d "$config" ]]; then
        echo && read -p "Remove config directory ($config)? [y/N] " -n 1 -r && echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$config" && print_success "Removed config"
        else
            print_info "Kept config (shortcuts preserved)"
        fi
    fi

    echo && print_success "Uninstall complete!"
    exit 0
}

install() {
    print_info "Installing shortcut..."

    # Get source file (local or download from GitHub)
    local src tmp_file=""
    if [[ -f "$SCRIPT_DIR/shortcut.sh" ]]; then
        src="$SCRIPT_DIR/shortcut.sh"
        print_info "Using local file"
    else
        print_info "Downloading from GitHub..."
        tmp_file=$(mktemp)
        if ! curl -sSLf "$GITHUB_URL" -o "$tmp_file"; then
            print_error "Download failed" && rm -f "$tmp_file" && exit 1
        fi
        src="$tmp_file"
        print_success "Downloaded"
    fi

    # Determine install directory
    local dir
    if [[ -d "$HOME/.local/bin" ]]; then
        dir="$HOME/.local/bin"
    elif [[ -d "$HOME/bin" ]]; then
        dir="$HOME/bin"
    else
        echo "No user bin directory found."
        read -p "Create ~/.local/bin? [Y/n] " -n 1 -r && echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            dir="/usr/local/bin"
            print_info "Will install to $dir (may need sudo)"
        else
            dir="$HOME/.local/bin"
            mkdir -p "$dir" && print_success "Created $dir"
        fi
    fi

    # Install
    local dest="$dir/shortcut"
    if install_file "$src" "$dest"; then
        print_success "Installed to $dest"
    else
        print_error "Installation failed"
        [[ -n "$tmp_file" ]] && rm -f "$tmp_file"
        exit 1
    fi

    [[ -n "$tmp_file" ]] && rm -f "$tmp_file"

    # Handle PATH
    if [[ ":$PATH:" != *":$dir:"* ]]; then
        echo && print_info "Warning: $dir not in PATH"

        local shell_config
        if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ "$SHELL" == *"fish"* ]]; then
            shell_config="$HOME/.config/fish/config.fish"
        else
            shell_config="$HOME/.bashrc"
        fi

        echo && echo "Add to $shell_config:"
        if [[ "$SHELL" == *"fish"* ]]; then
            echo "  set -gx PATH \$PATH $dir"
        else
            echo "  export PATH=\"\$PATH:$dir\""
        fi

        echo && read -p "Add automatically? [y/N] " -n 1 -r && echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [[ "$SHELL" == *"fish"* ]]; then
                echo "set -gx PATH \$PATH $dir" >> "$shell_config"
            else
                echo "export PATH=\"\$PATH:$dir\"" >> "$shell_config"
            fi
            print_success "Added to $shell_config"
            print_info "Run: source $shell_config (or restart terminal)"
        fi
    fi

    echo && print_success "Installation complete!"
    print_info "Try: shortcut add hello \"echo 'Hello World'\""
}

[[ "$1" == "--uninstall" ]] && uninstall || install
