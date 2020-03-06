destDir=~/.oh-my-zsh/plugins/ftools

if [ -d $destiDir ]  ; then
	rm $destDir 
fi
pluginsDir="$(pwd)/foh-my-zsh/plugins/ftools"
ln -s "$pluginsDir" $destDir
