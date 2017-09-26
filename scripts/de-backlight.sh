#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Get current brightness and round to nearest 10 {{{
BRIGHTNESS_RAW=$(xbacklight | perl -nl -MPOSIX -e 'print ceil($_)')
BRIGHTNESS_ROUNDED=$(echo "${BRIGHTNESS_RAW}" | perl -nl -MPOSIX -e 'print int(($_ / 10.0) + 0.5) * 10')
# }}}
# Increment / decrement brightness if argument was provided {{{
if [ $# -eq 1 ]; then
	if [ "$1" == "+" ]; then
		BRIGHTNESS_ROUNDED=$((BRIGHTNESS_ROUNDED + 10))
		BRIGHTNESS_ROUNDED=$((BRIGHTNESS_ROUNDED < 100 ? BRIGHTNESS_ROUNDED : 100))
		xbacklight -set "${BRIGHTNESS_ROUNDED}"
	elif [ "$1" == "-" ]; then
		BRIGHTNESS_ROUNDED=$((BRIGHTNESS_ROUNDED - 10))
		BRIGHTNESS_ROUNDED=$((BRIGHTNESS_ROUNDED > 10 ? BRIGHTNESS_ROUNDED : 10))
		xbacklight -set "${BRIGHTNESS_ROUNDED}"
	else
		echo "Usage:"
		echo -e "> $0\tGenerates a notification about the current brightness status"
		echo -e "> $0 +\tIncreases the brightness by 10% and generates a notification"
		echo -e "> $0 -\tDecreases the brightness by 10% and generates a notification"
		exit 1
	fi
fi
# }}}
# Define color gradient for brightness dots {{{
declare -a STATUS_COLORS
STATUS_COLORS[1]='#FFCC00'
STATUS_COLORS[2]='#FCC50A'
STATUS_COLORS[3]='#FABF15'
STATUS_COLORS[4]='#F8B920'
STATUS_COLORS[5]='#F5B32A'
STATUS_COLORS[6]='#F3AD35'
STATUS_COLORS[7]='#F1A740'
STATUS_COLORS[8]='#EEA14A'
STATUS_COLORS[9]='#EC9B55'
STATUS_COLORS[10]='#EA9560'
# }}}
# Calculate brightness level and display status message {{{
BRIGHTNESS_LEVEL=$((BRIGHTNESS_ROUNDED / 10))
STATUS_ACTIVE_DOTS=$(perl -E "print '•' x ${BRIGHTNESS_LEVEL}")
STATUS_INACTIVE_DOTS=$(perl -E "print '○' x (10 - ${BRIGHTNESS_LEVEL})")
STATUS="<span color=\"${STATUS_COLORS[$BRIGHTNESS_LEVEL]}\">${STATUS_ACTIVE_DOTS}</span>${STATUS_INACTIVE_DOTS}"

DUNST_IDF=~/.local/tmp/.dunst-brightness
if [[ -f "${DUNST_IDF}" && -r "${DUNST_IDF}" ]]; then
	dunstify -p -r $(cat "${DUNST_IDF}") -a brightness "Brightness: ${STATUS}" >"${DUNST_IDF}"
else
	dunstify -p -a brightness "Brightness: ${STATUS}" >"${DUNST_IDF}"
fi
# }}}

# vim:foldmethod=marker:foldlevel=0
