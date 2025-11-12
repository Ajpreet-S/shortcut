# Shortcut
A dead-simple bash script for managing your own custom command shortcuts. It's like a command alias manager that saves shortcuts to a config file.

## What Does It Do?
Ever find yourself typing the same long commands over and over? This script lets you save those commands with easy-to-remember names. Instead of typing `docker-compose -f docker-compose.prod.yml up -d`, you could just run `shortcut run deploy`.
It's basically a lightweight wrapper around a text file that stores your shortcuts.

## Quick Install
### One-line Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/Ajpreet-S/shortcut/main/installer.sh | bash
```

### Or Clone and Install
```bash
git clone https://github.com/Ajpreet-S/shortcut.git
cd shortcut
./installer.sh
```

The installer will:
- Automatically find the best installation location
- Add it to your PATH if needed
- Work on Linux and macOS

## Advanced Installation
If you prefer manual control, here are other ways to install:

### Option 1: Add to PATH
Add the directory containing the script to your PATH:
```bash
# Add this line to your ~/.bashrc or ~/.bash_profile
export PATH="$PATH:/path/to/shortcut"
```
Then reload your shell config:
```bash
source ~/.bashrc
```

### Option 2: Symlink to Existing PATH Directory
Create a symlink in a directory that's already in your PATH (like `~/bin` or `/usr/local/bin`):
```bash
# First, make sure ~/bin exists and is in your PATH
mkdir -p ~/bin

# Create the symlink
ln -s /path/to/shortcut/shortcut.sh ~/bin/shortcut

# If ~/bin isn't in your PATH, add it to ~/.bashrc
echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc
source ~/.bashrc
```

Now you can use `shortcut` from anywhere.

## Uninstall
To remove shortcut from your system:

```bash
./installer.sh --uninstall
```

Or if you installed via curl:
```bash
curl -sSL https://raw.githubusercontent.com/Ajpreet-S/shortcut/main/installer.sh | bash -s -- --uninstall
```

The uninstaller will:
- Remove the installed script
- Ask if you want to delete your configuration (your saved shortcuts)

## Usage
### Add a Shortcut
```bash
shortcut add <name> <command>
```

Example:
```bash
shortcut add gitlog "git log --oneline --graph --all"
```

### Run a Shortcut
```bash
shortcut run <name>
```
Example:
```bash
shortcut run gitlog
```

### List All Shortcuts
```bash
shortcut list
```

### Remove a Shortcut
```bash
shortcut remove <name>
```
Example:
```bash
shortcut remove deploy
```

## Where Are Shortcuts Stored?
All your shortcuts are saved in a plain text file at:
```
~/.config/shortcut/shortcuts.conf
```
You can edit this file directly if you want (it's just `name=command` pairs, one per line).

## Limitations
This script is intentionally simple, which means it has some quirks:
- **No duplicate checking**: If you `add` the same shortcut name twice, both will be saved. The first one will be used when you `run` it.
- **No editing**: To change a shortcut, you need to `remove` it and `add` it again, or edit the config file manually.
- **Shortcut names can't have spaces**: Use underscores or dashes instead (e.g., `my_command` instead of `my command`).
- **Security consideration**: The script uses `eval` to run commands, so only add shortcuts you trust. Don't let untrusted users add shortcuts to your config.
- **No command validation**: It won't check if your command is valid until you try to run it.

## Examples
Here are some practical shortcuts you might want to create:

```bash
# Quick navigation
shortcut add gohome "cd ~"
shortcut add goprojects "cd ~/projects"

# Git shortcuts
shortcut add gp "git push"
shortcut add gs "git status"
shortcut add gpl "git pull"

# System maintenance
shortcut add update "sudo apt update && sudo apt upgrade -y"
shortcut add cleanup "sudo apt autoremove && sudo apt autoclean"
```

## Contributing
This is a simple personal tool. Feel free to fork it and modify it for your own needs!

## License
Do whatever you want with it.
