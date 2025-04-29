# My Neovim Configuration

This is my first nvim configuration.
This whole setup is built for smartphone (Termux).

Right now it can have multiple errors that need to be fixed, and I am fixing them slowly.
I would appreciate if you also contribute and help point out or fix some issues.

> ⚡️ A lightweight and powerful Neovim setup focused on productivity.

![Screenshot_2025-04-28-14-32-47-40_84d3000e3f4017145260f7618db1d683](Screenshot_2025-04-28-14-32-47-40_84d3000e3f4017145260f7618db1d683.jpg)

## Features

- Modern Simple UI (Alpha dashboard).

- LSP and Autocompletion for selected languages (Python, Lua, TypeScript, etc.).

- Formatters and Linters (none-ls aka null-ls).

- Telescope and Fzf integration.

- Neotree for file exploring.

- Treesitter highlighting.

- Mobile friendly Keybindings.

- Debugging support with debug.lua.

- Nerd fonts icons (nvim-webdev-icons & mini-icons).

- Lualine and Bufferline integration.

- Which-key and Noice.nvim support.

## Requirements

- [Termux GitHub](https://github.com/termux/termux-app)

- [Termux Fdroid](https://f-droid.org/packages/com.termux)

- Neovim 0.10.0 or higher (Strongly recommend)

- Nerd Fonts (Download Termux Styling from F-Droid or GitHub and use any Nerd font).

- Git (For cloning and Managing repository).

## Now Some Serious Requirements ❗

> Before setting up anything, you should check these things in your Termux first:

### Language and Plugin Dependencies

### Lua Setup (Recommend)

- Lua 5.1+ (interpreter needed for Lua plugins and configs).

- Luarocks (package manager for Lua modules).

- luacheck (for Lua code linting and static analysis).

- Lua Language Server (for LSP support; recommend installing the smartphone-supported version from GitHub).

- As for Stylua it will not work in Termux. If you are able to find the arm64 V8 or v7 version depending on your smartphone then clone it via git. Then install Rust via `pkg install rust` and build it with cargo.

### Python Setup

- Python (required for Python development and Neovim Python integration).

- pynvim (Python client for Neovim; install via `pip install pynvim`).

- debugpy (for Python debugging support).

- flake8 (Python linter).

- black (Python code formatter).

- prettier ( you can leave this because Mason will install it automatically).

- pyright (It will be also installed automatically via Mason

> ruff will not work in Termux. If you are able to build and get it working then use ruff and remove flake8 and Black.

### Node.js Setup

- Node.js 20+ (required for some plugins and LSPs).

- npm (Node.js package manager).

- yarn (A better Node.js package manager for faster installation and better management).

- Neovim Node.js Client (`npm install -g neovim`) (enables Node-based plugins).

### Build Tools

- Ninja (for building LSP servers like Lua-language-server).

- CMake (recommended for building certain LSP tools or native extensions).

### Recommended Tools

- ripgrep (for fast file searching, improves Telescope performance).

- fd (simple, fast alternative to find command; enhances Telescope performance).

### Special Notes for Termux Users (Smartphone)

> Since this setup is optimized for smartphones (especially using Termux), make sure:

- Termux is updated to the latest version.

- You have a proper package source (F-Droid or official GitHub release).

- Compiling large servers like Lua-Language-Server might take time; clone smartphone-supported versions where available.

- Consider using lightweight alternatives where possible to avoid device overheating and battery drainage.

## Installation Commands (Short Summary)

### Basic packages

`pkg install git neovim nodejs python lua luarocks cmake ninja`

### Python packages

`pip install pynvim debugpy flake8 black`

### Node.js Neovim client

`npm install -g neovim`

### Lua checker

`luarocks install luacheck`

### Recommended additional tools

`pkg install ripgrep fd`

## Contribution 🫡

- Feel free to open an issue or create a pull request!💯

## License

This configuration is released under the MIT License. You are free to use, modify, and distribute it as you like, with proper attribution.

> Note: This setup relies on several third-party plugins and tools. Each plugin retains its own license and should be respected accordingly. Please refer to the plugin repositories for more information.

## Credits

### [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - for initial structure inspiration and best practices.

### Henry Misc – whose Neovim tutorials significantly guided the setup and workflow decisions.Watch the channel here: [Henry Misc on YouTube](https://youtu.be/KYDG3AHgYEs?si=6GgJ39KnuQJG7swc)

