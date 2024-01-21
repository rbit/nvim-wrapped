#!/usr/bin/env bash

# Guard against unset variables
TTY=${NEOVIM_TTY+1}
WAYLAND=${NEOVIM_WAYLAND+1}
XORGDSPL=${DISPLAY:-}
WLNDDSPL=${WAYLAND_DISPLAY:-}

# Switches override environment
case ${1:-} in
--nw)
	TTY=1
	WAYLAND=
	shift
	;;

--wayland)
	TTY=
	WAYLAND=1
	shift
	;;
esac

# Reality overrides switches
if [[ -z $XORGDSPL && -z $WLNDDSPL ]]; then
	TTY=1
	WAYLAND=
elif [[ -z $XORGDSPL && -z $TTY ]]; then
	WAYLAND=1
elif [[ -z $WLNDDSPL ]]; then
	WAYLAND=
fi

# Choose invocation target
if [[ -n $TTY ]]; then
	nvim "$@"
elif [[ -n $WAYLAND ]]; then
	QT_QPA_PLATFORM=wayland nvim-qt "$@"
else
	nvim-qt "$@"
fi
