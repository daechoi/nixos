#!/usr/bin/env zsh
#
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
  sed 's/Volume: //' | \
  xargs -I {} zsh -c 'qalc -t -s "decimal comma off" "{} * 100"')
    
muted=$(echo "$volume" | grep "MUTED")

if [[ -z $muted ]] && [[ $volume -ne 0 ]]; then 
  echo " $volume%"
else
  echo ""
fi
