#!/bin/bash
# shortcut - Manage custom command shortcuts

CONF="$HOME/.config/shortcut/shortcuts.conf"
mkdir -p "$(dirname "$CONF")"
touch "$CONF"

case "$1" in
    add)
        echo "$2=$3" >> "$CONF"
        ;;
    run)
        cmd=$(grep "^$2=" "$CONF" | cut -d'=' -f2-)
        [[ -n "$cmd" ]] && eval "$cmd" || echo "Shortcut '$2' not found"
        ;;
    list)
        cat "$CONF"
        ;;
    remove)
        sed -i "/^$2=/d" "$CONF"
        ;;
    *)
        echo "Usage: shortcut [add|run|list|remove] [name] [command]"
        ;;
esac
