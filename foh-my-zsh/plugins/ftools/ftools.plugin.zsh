function duf(){
	sudo du -k "$@" | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done | head -n 10 
}

alias bigFiles="duf /home"
