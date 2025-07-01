#!/usr/bin/env bash

# Получаем список мониторов через hyprctl
monitors=$(hyprctl monitors -j | jq 'length')

# Если монитор только один (встроенный) → блокируем экран
if [[ $monitors -eq 1 ]]; then
    hyprlock
fi
