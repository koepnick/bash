### Exports
export EDITOR=/usr/bin/vim    # the one and only editor
export HISTFILESIZE=300000    # save 300000 commands
export HISTCONTROL=ignoredups    # no duplicate lines in the history.
export HISTSIZE=100000
export http_proxy=''
export PATH=$PATH:/usr/sbin:/sbin:~/.opt/ec2-1.6.3.1/bin:~/.opt/AutoScaling-1.0.61.1/bin:~/.opt/CloudWatch-1.0.13.4/bin:~/.opt/ec2-ami-tools-1.4.0.7/bin

# export PATH=/prepend/path:$PATH
# export PATH=$PATH:/postpend/path

## EC2 Stuff
export EC2_PRIVATE_KEY=$HOME/.aws/pk-KGGVLVDGNMSH2DGKV3C6FSRLCZQJREJZ.pem
export EC2_CERT=$HOME/.aws/cert-KGGVLVDGNMSH2DGKV3C6FSRLCZQJREJZ.pem
export EC2_HOME=$HOME/.opt/ec2-1.6.3.1
export EC2_URL="https://us-west-1.ec2.amazonaws.com/"
export AWS_AUTO_SCALING_HOME=$HOME/.opt/AutoScaling-1.0.61.1
export AWS_CLOUDWATCH_HOME=$HOME/.opt/CloudWatch-1.0.13.4
export EC2_AMITOOL_HOME=$HOME/.opt/ec2-ami-tools-1.4.0.7
export JAVA_HOME=`which java | sed 's|/bin/java||'`

## Set up persistent color displays
if [[ -s ~/.bashdisplay ]] ; then
	export HOSTDISPLAY=`cat ~/.bashdisplay | grep host | awk -F':' '{ print $2 }'`
	export USERDISPLAY=`cat ~/.bashdisplay | grep user | awk -F':' '{ print $2 }'`
else
	export USERDISPLAY=0
	export HOSTDISPLAY=0
	echo "0" > ~/.bashdisplay
	echo "user:0" > ~/.bashdisplay
	echo "host:0" >> ~/.bashdisplay
fi
COLORS=$(tput colors)
if [[ $COLORS -ge 256 ]] ; then
	export TERM='xterm-256color'
else
	export TERM='linux'
fi
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize
#shopt -s histappend
export PROMPT_COMMAND='history -a'

### Set some colors
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color
COLORS=( $BLACK $BLUE $GREEN $CYAN $RED $PURPLE $BROWN $LIGHTGRAY $DARKGRAY $LIGHTBLUE $LIGHTGREEN $LIGHTCYAN $LIGHTRED $LIGHTPURPLE $YELLOW $WHITE $NC )

### Prompt

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi
if [ "$color_prompt" = yes ] ; then
	PS1="\e]2;\s \v | \H - \j Jobs \a[${COLORS[$USERDISPLAY]}\u${NC}@${COLORS[$HOSTDISPLAY]}\h${NC}:\w] - \t\n\! - \$ "
else
	export PS1="\e]2;\s \v | \H - \j Jobs \a[\u\@\h:\w] - \t\n\! - \$ "    
fi





### FUNCTIONS
# Backup
backup () { # FNCT backup - Backs up $1 to $1.bak.YYYY-MM-DD_Time
D=$(date +"%y-%m-%d_%T")
cp $1 $1.bak.$D
}


# Easy extract
extract () { # FNCT extract - Extracts $1 to CWD if: tar.bz2 tar.gz bz2 rar gz tar tbz2 tgz zip Z 7z
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# create junk file
function fakefile { # FNCT fakefile - Creates a blank file of size $1 megabytes
    perl -e "print '0' x 1024 x 1024 x $1" > $1-MB-fake-file.txt
}

# Sam's Styles
function PS2 # FNCT PS2 - Rotates PS1 Host
{
	# How many colors are there?
	TOTAL=${#COLORS[@]}
	TOTAL=`expr $TOTAL - 1`
	if [ $USERDISPLAY -lt $TOTAL ] ; then
		USERDISPLAY=`expr $USERDISPLAY + 1`
		export USERDISPLAY=$USERDISPLAY
	else
		USERDISPLAY=0
		export USERDISPLAY=0
	fi
	echo "user:$USERDISPLAY" > ~/.bashdisplay
	echo "host:$HOSTDISPLAY" >> ~/.bashdisplay
	PS1="\e]2;\s \v | \H - \j Jobs \a[${COLORS[$USERDISPLAY]}\u${NC}@${COLORS[$HOSTDISPLAY]}\h${NC}:\w] - \t\n\! - \$ "
}
function PS3 # FNCT PS3 - Rotates PS1 User
{
	# How many colors are there?
	TOTAL=${#COLORS[@]}
	TOTAL=`expr $TOTAL - 1`
	if [ $HOSTDISPLAY -lt $TOTAL ] ; then
		HOSTDISPLAY=`expr $HOSTDISPLAY + 1`
		export HOSTDISPLAY=$HOSTDISPLAY
	else
		HOSTDISPLAY=0
		export HOSTDISPLAY=0
	fi
	echo "user:$USERDISPLAY" > ~/.bashdisplay
	echo "host:$HOSTDISPLAY" >> ~/.bashdisplay
	PS1="\e]2;\s \v | \H - \j Jobs \a[${COLORS[$USERDISPLAY]}\u${NC}@${COLORS[$HOSTDISPLAY]}\h${NC}:\w] - \t\n\! - \$ "
}





# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; } #FNCT mktar - Creates tar of $1 directory (recursive)
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; } #FNCT mktgz - Creates gzipped tar of $1 directory (recursive)
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; } #FNCT mktbz - Creates bzipped tar of $1 directory (recursive)
# Encryption functions (Requires GPG)
encrypt () #FNCT encrypt - Encrypts $1 into gpg binary format
{
gpg -c --no-options "$1"
if [[ -s "$1.gpg" ]] ; then
	shred -u "$1"
fi
}

decrypt () #FNCT decrypt - Decrypts $1
{
gpg --no-options "$1"
ORIGINAL=$1
NEW=${ORIGINAL/\.gpg/}
if [[ -s "$NEW" ]] ; then
	shred -u "$ORIGINAL"
fi
}

function monitor() #FNCT monitor - Monitor a particular directory or file (ls $1)
{
	if [ -f $1 ] ; then
		while [ 1 -eq 1 ]
		do
			clear
			ls -lah $1
			sleep 2
		done
		
	fi
	if [ -d $1 ] ; then
		while [ 1 -eq 1 ]
		do
			clear
			ls -lah $1
			sleep 2
		done
	fi
		
}
function monitor_disk() #FNCT monitor_disk - Monitor attached disks /dev/sd*
{
	while [ 1 -eq 1 ]
	do
		clear
		\df -x tmpfs -x udev
		sleep 2
	done
}
function ii() # FNCT ii - Get current host information
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    echo -e "\n${RED}Local IP Address :$NC" ; ifconfig | grep "inet addr:" | awk -F" " '{ print $2 }' | awk -F":" '{ print $2 }'
	AR=(`apt-get upgrade -s | egrep "^Inst" | awk -F " " '{ print $2 }'`)
	if [ ${#AR[@]} -gt 0 ] ; then
	echo -e "\n${RED}Security updates are available for the following ${#AR[@]} packages :$NC "
	INC=0
	for UPDATE in ${AR[@]}
	do
		if [ $INC -eq 0 ] ; then
			echo -ne "$UPDATE\t\t\t\t"
			INC=1
		else
			echo -ne "$UPDATE\n"
			INC=0
		fi
	done
	else
	echo -e "\n${RED}System security is up-to-date$NC "
	fi
}

function ddos() # FNCT ddos - Helps determine if a DDOS is being launched
{
while [ 1 -eq 1 ]
do
        ddos_once
        sleep 5
done
}
function ddos_once()
{
UN=/tmp/_unique
AL=/tmp/_all
SU=/tmp/_uniqueSub
SA=/tmp/_allSub


netstat -pnt | grep :80 | awk '{ print $5 }' | awk -F':' '{ print $1 }' | sort -u > $UN
netstat -pnt | grep :80 | awk '{ print $5 }' | awk -F':' '{ print $1 }' | sort > $AL

netstat -pnt | grep :80 | awk '{ print $5 }' | awk -F'.' '{ print $1 "." $2 "." $3 ".0" }' | sort -u > $SU
netstat -pnt | grep :80 | awk '{ print $5 }' | awk -F'.' '{ print $1 "." $2 "." $3 ".0" }' | sort > $SA

clear
echo "Unique IP Addresses"
echo "-------------------------------------"

UNIQUE=`cat $UN`
UNIQUESUBS=`cat $SU`

for i in $UNIQUE
do
        COUNT=`tr -s ' ' '\n' < $AL | grep -c $i`
        echo -e "$i\t- $COUNT Connections"
done
echo -e "-------------------------------------\n\n"
echo "Unique Subnets"
echo "-------------------------------------"
for j in $UNIQUESUBS
do
        COUNT=`tr -s ' ' '\n' < $SA | grep -c $j`
        echo -e "$j\t- $COUNT Connections"
done
echo "-------------------------------------"
echo -e "Total\t\t-" `cat $AL | wc -l` "Connections"
rm $UN $AL $SU $SA
}
function trace() # FNCT trace - Interactive tracing of host $1
{
	mtr $1
}
function ?
{
	cat ~/.bash_aliases | grep FNCT | awk -F "FNCT " '{ print $2 }' | sort | awk -F " - " '{ print $1 " | " $2 }' | column -s\| -t -x
}
function url_info() # FNCT url_info - Returns info about URL $1
{
doms=$@
if [ $# -eq 0 ]; then
	echo -e "No domain given\nTry $0 domain.com domain2.org anyotherdomain.net"
fi
for i in $doms; do
	_ip=$(host $i|grep 'has address'|awk {'print $4'})
	if [ "$_ip" == "" ]; then
		echo -e "\nERROR: $i DNS error or not a valid domain\n"
		continue
	fi
	ip=`echo ${_ip[*]}|tr " " "|"`
	echo -e "\nInformation for domain: $i [ $ip ]\nQuerying individual IPs"
 	for j in ${_ip[*]}; do
		echo -e "\n$j results:"
		whois $j |egrep -w 'OrgName:|City:|Country:|OriginAS:|NetRange:'
	done
done
}
# Displays metadata for specified media file
#   $1 = media file name

function toMP4() #FNCT toMP4 - Converts the input file to a high profile mp4
{
	if [ -z "$2" ] ; then
		CRF=14
	else
		CRF=$2
	fi
	filename=$(basename "$1")
	extension="${filename##*.}"
	filename="${filename%.*}"
	newext=".mkv"
	newname="$filename$newext"
	if [ "$extension" == "mp4" ] ; then
		newname="$filename-new.mkv"
	fi
	echo "Will convert $1 to $newname"
	echo -e "With ffmpeg -i \"$1\" -vcodec libx264 -preset slow -crf $CRF -threads 0 -acodec libfaac -tune film -ab 160k \"$newname\""
	ffmpeg -i "$1" -vcodec libx264 -preset veryslow -crf $CRF -threads 0 -acodec libfaac -tune film -ab 160k "$newname"
}

function i() { # FNCT i - Displays information about mp3 file $1
    EXT=`echo "${1##*.}" | sed 's/\(.*\)/\L\1/'`
    if [ "$EXT" == "mp3" ]; then
        id3v2 -l "$1"
        echo
        mp3gain -s c "$1"
    elif [ "$EXT" == "flac" ]; then
        metaflac --list --block-type=STREAMINFO,VORBIS_COMMENT "$1"
    else
        echo "ERROR: Not a supported file type."
    fi
}
function e? # FNCT e? - Prints current environment data
{
	clear
	echo Current Exports
	echo Editor - $EDITOR
	echo Bash History - $HISTSIZE
	echo Proxy - $http_proxy
	echo Path - $PATH
}
### ALIASES
## Screen stuff
alias screen-grid='screen -c ~/.screen/conf/grid'
alias screen-full='screen -c ~/.screen/conf/full'


## Keeping things organized
alias ll='ls -lah --color=auto'
alias ls='\ls -lh --color=auto'
alias la='ls -A'
alias mkdir='mkdir -p -v'
alias df='df -h'
alias dfh='df -h -x tmpfs -x udev'
alias du='du -h -c'
alias reload='source ~/.bashrc'


## Sudo fixes
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias orphans='sudo deborphan | xargs sudo apt-get -y remove --purge'
alias cleanup='sudo apt-get autoclean && sudo apt-get autoremove && sudo apt-get clean && sudo apt-get remove && orphand'
alias updatedb='sudo updatedb'
alias search="apt-cache search"


## General
alias a?='clear ; cat ~/.bash/alias_help'
alias f?='clear ; cat ~/.bash/function_help'
alias s?='clear ; cat ~/.bash/snippets_help'
alias identify='identify -verbose'
alias startup='sysv-rc-conf'

### Misc.
alias rmatrix='echo -ne "\e[31m" ; while true ; do echo -ne "\e[$(($RANDOM % 2 + 1))m" ; tr -c "[:print:]" " " < /dev/urandom | dd count=1 bs=80 2> /dev/null ; sleep .05 ; done'
alias gmatrix='echo -ne "\e[32m" ; while true ; do echo -ne "\e[$(($RANDOM % 2 + 1))m" ; tr -c "[:print:]" " " < /dev/urandom | dd count=1 bs=80 2> /dev/null ; sleep .05 ; done'
#Automatically do an ls after each cd
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && \ls --color=auto -lh
  else
    builtin cd ~ && \ls --color=auto -lh
  fi
}
#COOKIE=`xauth list | grep ":10"` ; sudo xauth add $COOKIE
