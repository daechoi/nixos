# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

# Returns the battery status: "Full", "Discharging", or "Charging".
battery_status=$(cat /sys/class/power_supply/CMB0/status)

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
  sed 's/Volume: //' | \
  xargs -I {} zsh -c 'qalc -t -s "decimal comma off" "{} * 100"')
    
muted=$(echo "$volume" | grep "MUTED")

if [[ -z $muted ]] && [[ $volume -ne 0 ]]; then 
  vol_level="  $volume%"
else
  vol_level=""
fi

echo $uptime_formatted ↑ $linux_version 🐧 $battery_status 🔋 $date_formatted "$vol_level"
