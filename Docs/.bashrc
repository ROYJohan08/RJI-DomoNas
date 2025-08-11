case $- in
    *i*) ;;
      *) return;;
esac
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

##################################################
#                Directory alias                 #
##################################################

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cddomonas='cd /etc/RJIDomoNas/'
alias cdseries1='cd /media/Series01'
alias cdseries2='cd /media/Series02'
alias cdseries3='cd /media/Series03'
alias cdfilms1='cd /media/Films01'
alias cdfilms2='cd /media/Films02'
alias cddownbox='cd /media/Runable/DownBox/completed/'
alias cdseedbox='cd /media/Runable/SeedBox/'
alias cddocs1='cd /media/Docs01/'
alias cdrunable='cd /media/Runable'

##################################################
#                Commands alias                  #
##################################################

alias bashvm='bash /etc/RJIDomoNas/Docker.sh'
alias lsvm='docker ps'
alias sudo='sudo '
alias samba='service smbd'
alias glances='glances -w &'
alias cparchive='cp -a -d -f -R -u -v '
alias archive='bash /etc/RJIDomoNas/Archive.sh '

##################################################
#                  Disk alias                    #
##################################################

alias ldisk='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,UUID'
alias mdisk='mount -a --onlyonce'

##################################################
#                  Update alias                  #
##################################################

alias agu='sudo apt-get update -y'
alias agg='sudo apt-get upgrade -y'
alias agd='sudo apt-get dist-upgrade -y'
alias upup='sudo wget -r -O /etc/RJIDomoNas/Update.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Update.sh'
alias rjiup='sudo bash /etc/RJIDomoNas/Update.sh'
alias maj='agu && agg && agd && upup && rjiup'


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##################################################
#    @Date : 05/08/2025 12:25                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
