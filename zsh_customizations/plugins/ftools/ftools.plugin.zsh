function duf(){
	sudo du -k "$@" | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done | head -n 10 
}

alias bigFiles="duf /home"

alias git_clean_merged="git --no-pager branch --merged master | grep -v master > /tmp/git_clean && vim /tmp/git_clean && cat /tmp/git_clean | xargs git branch -D | rm -rf /tmp/git_clean"
