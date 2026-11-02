#!/bin/sh
input=$(cat)

DIM='\033[2;37m'
ORANGE='\033[38;5;173m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

field() {
  echo "$input" | jq -r "$1 // empty"
}

format_tokens() {
  if [ "$1" -ge 1000000 ]; then
    printf '%sM' $((($1 + 500000) / 1000000))
  else
    printf '%sk' $((($1 + 500) / 1000))
  fi
}

# Prints " | <label>: <remaining>% left", colored by how little is left
print_limit() {
  [ -z "$2" ] && return
  left=$((100 - $(printf '%.0f' "$2")))
  [ "$left" -lt 0 ] && left=0
  if [ "$left" -lt 10 ]; then
    color=$RED
  elif [ "$left" -lt 30 ]; then
    color=$YELLOW
  else
    color=$ORANGE
  fi
  printf " ${DIM}|${RESET} ${DIM}%s:${RESET} ${color}%s%% left${RESET}" "$1" "$left"
}

# Prints the time until an epoch timestamp, e.g. "3d 4h", "5h 12m" or "7m"
format_reset() {
  seconds=$(($1 - $(date +%s)))
  [ "$seconds" -lt 0 ] && seconds=0
  days=$((seconds / 86400))
  hours=$((seconds % 86400 / 3600))
  minutes=$((seconds % 3600 / 60))
  if [ "$days" -gt 0 ]; then
    printf '%sd %sh' "$days" "$hours"
  elif [ "$hours" -gt 0 ]; then
    printf '%sh %sm' "$hours" "$minutes"
  else
    printf '%sm' "$minutes"
  fi
}

context_tokens=$(field '.context_window.total_input_tokens')
context_max=$(field '.context_window.context_window_size')
model=$(field '.model.display_name')
effort=$(field '.effort.level')
session_used=$(field '.rate_limits.five_hour.used_percentage')
week_used=$(field '.rate_limits.seven_day.used_percentage')
week_reset=$(field '.rate_limits.seven_day.resets_at')

if [ -n "$model" ]; then
  printf "${DIM}model:${RESET} ${ORANGE}%s${RESET}" "$model"
  [ -n "$effort" ] && printf " ${DIM}(${RESET}${ORANGE}%s${RESET}${DIM})${RESET}" "$effort"
  printf " ${DIM}|${RESET} "
fi

printf "${DIM}context:${RESET} ${ORANGE}%s${RESET}" "$(format_tokens "${context_tokens:-0}")"
[ -n "$context_max" ] && printf "${DIM} / %s${RESET}" "$(format_tokens "${context_max%.*}")"

print_limit session "$session_used"
print_limit week "$week_used"
if [ -n "$week_reset" ]; then
  reset_label=$(format_reset "${week_reset%.*}")
  [ -n "$reset_label" ] && printf " ${DIM}(resets in %s)${RESET}" "$reset_label"
fi
echo
