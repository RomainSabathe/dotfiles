#!/usr/bin/env bash

killall -q polybar
echo "---" | tee -a /tmp/polybar1.log
polybar -c $HOME/.config/polybar/config example 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
