#!/bin/bash
curDir="$(pwd)"

function checkSuccess() {
	if [ $? -ne 0 ]; then
		echo "Last command hasn't success"
	fi

}

function eco() {
	echo "]>> $1"
}

# Colored log helpers: info, warning, error
# Honors NO_COLOR env var or non-interactive terminals.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
	C_RESET='\033[0m'
	C_GREEN='\033[1;32m'
	C_YELLOW='\033[1;33m'
	C_RED='\033[1;31m'
else
	C_RESET=''
	C_GREEN=''
	C_YELLOW=''
	C_RED=''
fi

info() {
	# Print informational message in green to stdout
	printf "%b %s\n" "${C_GREEN}[INFO]${C_RESET}" "$*"
}

warn() {
	# Print warning message in yellow to stdout
	printf "%b %s\n" "${C_YELLOW}[WARN]${C_RESET}" "$*"
}

warning() {
	# Print warning message in yellow to stdout
	printf "%b %s\n" "${C_YELLOW}[WARN]${C_RESET}" "$*"
}

error() {
	# Print error message in red to stderr
	printf "%b %s\n" "${C_RED}[ERROR]${C_RESET}" "$*" >&2
}

