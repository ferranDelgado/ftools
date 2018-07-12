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
