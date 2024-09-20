# .bashrc

# Set colored terminal prompt as "hostname:current directory$ "
# Not sure if this works on centos yet
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

#######################################################
# GENERAL ALIAS'S
#######################################################

# Niceities
alias cd..="cd .."
alias files="xdg-open"
alias rm="rm -i"  # Interactive mode delete
alias hs="cd ~/ && ls"
# alias up="cd .." Created a function for this
alias home="cd ~/"
alias root="sudo su"
alias mkdir="mkdir -pv"  # Creates parent directories if needed
alias hist="history"
alias jobs="jobs -l"
alias path="echo -e ${PATH//:/\\n}"

# Power commands
alias shutdown="sudo shutdown -P now"
alias reboot="sudo shutdown -r now"

# Grep shorthands
alias grep="grep --color=auto"  # Colorize grep command output

# ls shorthands
alias l.="ls -d .* --color=auto"
alias ls="ls -C --color=auto"  # Make 'normal' ls nice with Columns and Colors
alias lm="ls -lhA --color=auto | more"  # For big directories
alias ll="ls -lh --color=auto"
alias la="ls -lhA --color=auto"
alias lar="ls -lhAR --color=auto | more"  # Recursive subdirectories, listed out
alias lcr="ls -CAR --color=auto | more"  # Recursive subdirectories, by column

# Time
alias now="date +"%T""
alias nowtime=now
alias nowdate="date +\"%d-%m-%Y\""

# Networking
alias ports="netstat -tulanp"

# Updates
alias update="dnf -y check-update && sudo dnf -y upgrade"

# File Creation
alias mkfile='function _mkfile(){ mkdir -p "$(dirname "$1")" && touch "$1"; }; _mkfile'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi


#######################################################
# EXPORTS
#######################################################

export PATH

export PATH=$PATH:/usr/local/go/bin

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"


export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

PATH=~/.console-ninja/.bin:$PATH

#######################################################
# SPECIAL FUNCTIONS
#######################################################


# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
        # if the file is --help or -h, print the help message
        elif [ $archive == "--help" ] || [ $archive == "-h" ]; then
            echo "Usage: extract <file> [<file> ...]"
            echo "Extracts the given archive(s) to the current directory."
            echo "Supported formats: tar.bz2, tar.gz, bz2, rar, gz, tar, tbz2, tgz, zip, Z, 7z"
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Goes up a specified number of directories  (i.e. up 4)
up () {
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}


# Show the current distribution
distribution ()
{
	local dtype
	# Assume unknown
	dtype="unknown"
	
	# First test against Fedora / RHEL / CentOS / generic Redhat derivative
	if [ -r /etc/rc.d/init.d/functions ]; then
		source /etc/rc.d/init.d/functions
		[ zz`type -t passed 2>/dev/null` == "zzfunction" ] && dtype="redhat"
	
	# Then test against SUSE (must be after Redhat,
	# I've seen rc.status on Ubuntu I think? TODO: Recheck that)
	elif [ -r /etc/rc.status ]; then
		source /etc/rc.status
		[ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && dtype="suse"
	
	# Then test against Debian, Ubuntu and friends
	elif [ -r /lib/lsb/init-functions ]; then
		source /lib/lsb/init-functions
		[ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && dtype="debian"
	
	# Then test against Gentoo
	elif [ -r /etc/init.d/functions.sh ]; then
		source /etc/init.d/functions.sh
		[ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && dtype="gentoo"
	
	# For Mandriva we currently just test if /etc/mandriva-release exists
	# and isn't empty (TODO: Find a better way :)
	elif [ -s /etc/mandriva-release ]; then
		dtype="mandriva"

	# For Slackware we currently just test if /etc/slackware-version exists
	elif [ -s /etc/slackware-version ]; then
		dtype="slackware"

	fi
	echo $dtype
}

# Show the current version of the operating system
ver () {
	local dtype
	dtype=$(distribution)

	if [ $dtype == "redhat" ]; then
		if [ -s /etc/redhat-release ]; then
			cat /etc/redhat-release && uname -a
		else
			cat /etc/issue && uname -a
		fi
	elif [ $dtype == "suse" ]; then
		cat /etc/SuSE-release
	elif [ $dtype == "debian" ]; then
		lsb_release -a
		# sudo cat /etc/issue && sudo cat /etc/issue.net && sudo cat /etc/lsb_release && sudo cat /etc/os-release # Linux Mint option 2
	elif [ $dtype == "gentoo" ]; then
		cat /etc/gentoo-release
	elif [ $dtype == "mandriva" ]; then
		cat /etc/mandriva-release
	elif [ $dtype == "slackware" ]; then
		cat /etc/slackware-version
	else
		if [ -s /etc/issue ]; then
			cat /etc/issue
		else
			echo "Error: Unknown distribution"
			exit 1
		fi
	fi
}

