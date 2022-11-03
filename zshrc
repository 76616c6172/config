# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
 
READNULLCMD=${PAGER:-/usr/bin/pager}
 
# An array to note missing features to ease diagnosis in case of problems.
typeset -ga debian_missing_features
 
# if [[ -z "${DEBIAN_PREVENT_KEYBOARD_CHANGES-}" ]] &&
#    [[ "$TERM" != 'emacs' ]]
# then
 
    typeset -A key
    key=(
        BackSpace  "${terminfo[kbs]}"
        Home       "${terminfo[khome]}"
        End        "${terminfo[kend]}"
        Insert     "${terminfo[kich1]}"
        Delete     "${terminfo[kdch1]}"
        Up         "${terminfo[kcuu1]}"
        Down       "${terminfo[kcud1]}"
        Left       "${terminfo[kcub1]}"
        Right      "${terminfo[kcuf1]}"
        PageUp     "${terminfo[kpp]}"
        PageDown   "${terminfo[knp]}"
    )
 
    function bind2maps () {
        local i sequence widget
        local -a maps
 
        while [[ "$1" != "--" ]]; do
            maps+=( "$1" )
            shift
        done
        shift
 
        sequence="${key[$1]}"
        widget="$2"
 
        [[ -z "$sequence" ]] && return 1
 
        for i in "${maps[@]}"; do
            bindkey -M "$i" "$sequence" "$widget"
        done
    }
 
    # bind2maps emacs             -- BackSpace   backward-delete-char
    # bind2maps       viins       -- BackSpace   vi-backward-delete-char
    # bind2maps             vicmd -- BackSpace   vi-backward-char
    # bind2maps emacs             -- Home        beginning-of-line
    # bind2maps       viins vicmd -- Home        vi-beginning-of-line
    # bind2maps emacs             -- End         end-of-line
    # bind2maps       viins vicmd -- End         vi-end-of-line
    # bind2maps emacs viins       -- Insert      overwrite-mode
    # bind2maps             vicmd -- Insert      vi-insert
    # bind2maps emacs             -- Delete      delete-char
    # bind2maps       viins vicmd -- Delete      vi-delete-char
    # bind2maps emacs viins vicmd -- Up          up-line-or-history
    # bind2maps emacs viins vicmd -- Down        down-line-or-history
    # bind2maps emacs             -- Left        backward-char
    # bind2maps       viins vicmd -- Left        vi-backward-char
    # bind2maps emacs             -- Right       forward-char
    # bind2maps       viins vicmd -- Right       vi-forward-char
 
    # Make sure the terminal is in application mode, when zle is
    # active. Only then are the values from $terminfo valid.
    if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
        function zle-line-init () {
            emulate -L zsh
            printf '%s' ${terminfo[smkx]}
        }
        function zle-line-finish () {
            emulate -L zsh
            printf '%s' ${terminfo[rmkx]}
        }
        zle -N zle-line-init
        zle -N zle-line-finish
    else
        for i in {s,r}mkx; do
            (( ${+terminfo[$i]} )) || debian_missing_features+=($i)
        done
        unset i
    fi
 
    unfunction bind2maps
 
# fi # [[ -z "$DEBIAN_PREVENT_KEYBOARD_CHANGES" ]] && [[ "$TERM" != 'emacs' ]]

# tab completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin  \
                                           /usr/local/bin   \
                                           /usr/sbin        \
                                           /usr/bin         \
                                           /sbin            \
                                           /bin             \
                                           /usr/X11R6/bin   \
                                           /home/$USER/Apps \
 
(( ${+aliases[run-help]} )) && unalias run-help
autoload -Uz run-help

# advanced completion
autoload -Uz compinit
compinit


# fzf tab
# git clone https://github.com/Aloxaf/fzf-tab
#source ~/projects/fzf-tab/fzf-tab.plugin.zsh
source ~/.configuration/fzf/fzf-tab.plugin.zsh


# arrow-key driven interface for autocomplete menu
#zstyle ':completion:*' menu select
 
# History in cache directory:
HISTSIZE=20000
SAVEHIST=20000
HISTFILE=/home/$USER/.zsh_history
setopt SHARE_HISTORY
 
# Enable colors and change prompt:
autoload -U colors && colors

#PS1="%B% %F{#5f5ff}%n@%M%f%F{#5f5ff}%}:%f%F{#5f5fff}%}%~%}%f%F{#85f5fff}%}$%b %f% "
#PS1="%B% %F{#5f00ff}%n@%M%f%F{#87ffaf}%}:%f%F{#5f5fff}%}%~%}%f%F{#87ffaf}%}$%b %f% "
#PS1="%B%{%F{#87ffaf}%}%n@%M %f%{%F{#5f00ff}%}%~%}%f%b$ "
 
# vim mode!
set -o vi
# reverse porting CTRL+R shell search from emacs bindings because I like it!
bindkey "^R" history-incremental-search-backward

# export path
export PATH="$HOME/Apps:$PATH"
export PATH="/home/$USER/Tools/bin:/home/$USER/.shellscripts:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export EDITOR="vi"

## EXPERIMENTAL
#setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt ksharrays           # arrays start at 0
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
#export PROMPT_EOL_MARK=""

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"



# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\*\(.*\)/on\1/p'
    #git branch 2> /dev/null | sed -n -e 's/^\*\(.*\)/\1/p'
}
#COLOR_GIT=$'\u001b[31m'
setopt PROMPT_SUBST

# Prompt
if [ "$USER" = valar ]; then
	# PROMPT=$'%b%F{%(#.white.white)}「%B%F{reset}%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.white.white)} 」%B%(#.%F{blue}$§.%F{green}§)%b%F{reset} '        
  # #.white.white)

#    PROMPT=$'%F{%(#.white.white)}┌──%F{%(#.white.white)}「%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} 」\n└─%(#.%F{blue}$§.%F{blue}§)%(#.%F{red}#.%F)%B%F{reset} '
#      RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'


    #PROMPT=$'%F{%(#.white.white)}████╗\n██╔═╝%F{%(#.white.white)}「%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} 」\n╚═╝%(#.%F{blue}$§.%F{blue}§)%(#.%F{red}#.%F)%B%F{reset} '
      #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'
      
# ═
# ╔═
# ╗
# ╝
#
# ╔═══╗
# ║ ╔═╝
# ╚═╝
# ╔═╗
# ║ ║
# ╚═╝
#
#
#
#
# set prompt symbol color
SYMBOL_COLOR="green"
# check if we're in a nix shell
IS_NIX_SHELL=false
SYMB='§'
if  [[ $PATH == *"nix/store"* ]] ; then
  IS_NIX_SHELL=true
  SYMB='❄'
  SYMBOL_COLOR="default"
  #echo "nix shell loaded"
fi

#PROMPT=$'%F{%(#.white.white)}╔═ 「%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} 」$(parse_git_branch)\n╚%F{%#.white.white)}%F{blue}§%(#.%F{red}#.%F)%B%F{reset} '
#RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'
PROMPT=$'%F{%(#.white.white)} %F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} $(parse_git_branch)\n%F{%#.white.white)}%F{$SYMBOL_COLOR}$SYMB%(#.%F{red}#.%F)%B%F{reset} '
RPROMPT=$'%(?.. %? %F{red}%B•%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'

else
#PROMPT=$'%F{%(#.white.white)}┌──${debian_chroot:+($debian_chroot)──}(%B%F{%(#.red.white)}%n%(#.💀.㉿)%m%b%F{%(#.blue.white)})-「%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} 」\n└─%B%(#.%F{red}#.%F{#.white.white}§)%b%F{reset} '
#RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
#RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'
#PROMPT=$'%F{%(#.white.white)}╔═ 「%F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} 」%F{%(#.white.white)}as %B%F{%(#.red.white)}%n@%m%b%F{%(#.blue.white)} $(parse_git_branch)\n╚%F{%#.white.white)}%F{blue}§%(#.%F{red}#.%F)%B%F{reset} '
#RPROMPT=$'%(?.. %? %F{red}%B•%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'

PROMPT=$'%F{%(#.white.white)} %F{%(#.blue.blue)}%(6~.%-1~/…/%4~.%5~)%b%F{reset}%F{%(#.blue.white)} $(parse_git_branch)\n%F{%#.white.white)}%F{green}§%(#.%F{red}#.%F)%B%F{reset} '
RPROMPT=$'%(?.. %? %F{red}%B•%b%F{reset})%(1j. %j %F{blue}%B⚙%b%F{reset}.)'
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE='\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
*)
    ;;
esac

# set if you want a newline before each prompt
#new_line_before_prompt=''
new_line_before_prompt='yes'
precmd() {
    # Print the previously configured title
    print -Pn "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
	if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
	    _NEW_LINE_BEFORE_PROMPT=1
	else
      # this is the line that is printed after each prompt, by default it's a newline
	    print ""
	fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias ls='ls --classify --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi



# alias sc='. sc' # this is needed to not run in a subshell, and allow the script to change my dir

# alias code='dbus-launch code' # no longer needed

# autopushd
# DIRSTACKFILE="$HOME/.cache/zsh/dirs"
# if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
#   dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#   [[ -d $dirstack[1] ]] && cd $dirstack[1]
# fi
# # called everytime pwd is changed
# chpwd() {
#   print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
# }


# autopushd
#DIRSTACKSIZE=10
#DIRSTACKFILE=~/.cache/zsh/dirstack
setopt autopushd
setopt pushdtohome
setopt pushdignoredups
setopt pushdsilent
setopt pushdminus
DIRSTACKSIZE=9

# FIXME currently only saves the last directory on shell close
# DIRSTACKFILE=~/.zdirs
# load dirs into stack from given file.
# if [[ -f $DIRSTACKFILE && $#dirstack -eq 0 ]]; then
#     dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#     [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
# fi
## At last we add a function to store dirs stack on dir change.
# function chpwd () {
#     print -l $PWD ${(u)dirstack} > $DIRSTACKFILE
#}

# Alternate dirstack
DIRSTACKFILE=~/.cache/zsh/dirstack
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
 dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
  sort $DIRSTACKFILE | uniq > $DIRSTACKFILE
  print -l $PWD ${(u)dirstack} >> $DIRSTACKFILE
}


#
# enable auto-suggestions based on the history
#if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
#    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#    # change suggestion color
#    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
#fi

# Haskell environment
[ -f "/home/valar/.ghcup/env" ] && source "/home/valar/.ghcup/env" # ghcup-env

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform


# Fuzzy Finder Command Search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



# Aliases
# alias ls='ls -l --color=auto'
#alias ls='ls --classify --color=auto'
alias l='ls --color=auto'
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias tr='tree -L 3 -C'
alias gdb='gdb -q'
alias tmux='tmux -2u' # forces tmux into accepting colors and special charactes
alias la='ls -A'
alias d='docker'
alias tf='terraform'
alias p='python3'
alias g='git'
alias cat='bat --paging=never --theme="base16"'

# fzr scripts
# I LOVE THEESE
alias v='vi -o $(find "." -type f | fzf)'
alias fd='. fd' # fuzzy directory
#
alias cdi='. cdi' # change directory interactively, even hidden ones - the big guns :)
alias f='. /home/valar/.shellscripts/f' # find wrapper
#alias v='vi -o `fzf`' # vim fuzzy - fuzzy find a file recurssively from pwd and open in vim
#alias vif='vi -o `$(find -name "**" -type f | fzf)`'
alias vi='nvim'

# other
alias top='btop'

alias nix='n-i-x'
