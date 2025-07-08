#!/bin/bash
option=$(echo -e "🔒 Lock\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown" | rofi -dmenu -p "Power Menu" -theme ~/.config/rofi/powermenu.rasi)

case "$option" in
    "🔒 Lock") hyprlock ;;
    "🚪 Logout") hyprctl dispatch exit ;;
    "🔄 Reboot") systemctl reboot ;;
    "⏻ Shutdown") systemctl poweroff ;;
esac
