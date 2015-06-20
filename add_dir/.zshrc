# dummy function to load bash shell script file
# without "command not found: shopt" error
shopt () {}

# Completion
fpath=(~/.linuxbrew/share/zsh/site-functions/ $fpath)

for RC_FILE in $(find ~/.zshrc.d/ -type f -or -type l | sort); do
    . "${RC_FILE}"
done
