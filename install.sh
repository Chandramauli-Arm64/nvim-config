#!/bin/bash

# Clone your Neovim config
echo "Setting up Chandramauli's Neovim config..."

# Backup existing nvim config if any
if [ -d "$HOME/.config/nvim" ]; then
    echo "Existing Neovim config found, backing it up to ~/.config/nvim_backup"
    mv ~/.config/nvim ~/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)
fi

# Clone your GitHub repo
git clone https://github.com/Chandramauli-Arm64/nvim-config.git ~/.config/nvim

echo "Neovim config installed!"
echo "Now open Neovim and it will auto-install plugins using Lazy.nvim."
