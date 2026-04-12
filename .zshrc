zstyle ':completion:*' completer _expand _complete _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %l \(%p\): Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' '' 'm:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' menu select=10
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt 'The command you typed contained %e errors. Possible corrections below.'
zstyle ':completion:*' select-prompt %SScrolling active%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose false
zstyle ':completion::complete:*' use-cache 1
zstyle :compinstall filename '/etc/zshrc'

zmodload -i zsh/mathfunc
autoload zsh/terminfo colors
colors
autoload -Uz compinit vcs_info
compinit
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory sharehistory autocd transient_rprompt hist_ignore_all_dups prompt_subst
bindkey -e

if [[ "$terminfo[colors]" = 256 ]]; then
    root_color="%{[38;05;196m%}"
    user_color="%{[38;05;83m%}"
    tty_color="%{[38;05;96m%}"

    virt_color="%{[38;05;208m%}"
    time_color="%{[38;05;75m%}"
    error_color="%{[38;05;196m%}%S"
    end_error_color="%s"

    vcs_name_color="%{[38;05;109m%}"
    vcs_staged_color="%{[38;05;83m%}"
    vcs_unstaged_color="%{[38;05;184m%}"
    vcs_branch_color="%{[38;05;184m%}"
    vcs_action_color="%{[38;05;224m%}"

    # Ternary expression
    # %(test.if_true.if_false)
    # The ! test returns true if the shell is running with priveleges
    userpart="%(!.$root_color%m.$user_color%n@%m)"

    path_color="%{[38;05;33m%}"
    prompt_color="%{[38;05;227m%}"
else
    if [[ "$terminfo[colors]" -lt 8 ]]; then
        unsetopt zle
        userpart="%n@%m";
    else
        root_color="%{$fg[red]%}"
        user_color="%{$fg[green]%}"
        tty_color="%{$fg[magenta]%}"

        virt_color="%{$fg[orange]%}"
        time_color="%{$fg[blue]%}"
        error_color="%{$fg[red]%}%S"
        end_error_color="%s"

        vcs_name_color="%{$fg[cyan]%}"
        vcs_staged_color="%{$fg[green]%}"
        vcs_unstaged_color="%{$fg[yellow]%}"
        vcs_branch_color="%{$fg[yellow]%}"
        vcs_action_color="%{$fg[orange]%}"

        userpart="%(!.$root_color%m.$user_color%n@%m)"

        path_color="%{$fg[blue]%}"
    fi
fi

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' stagedstr "$vcs_staged_color*"
zstyle ':vcs_info:*' unstagedstr '$vcs_unstaged_color*'
zstyle ':vcs_info:*' formats "$vcs_name_color(%s) $vcs_branch_color%b"
zstyle ':vcs_info:*' actionformats "$vcs_name_color(%s) $vcs_branch_color%b$vcs_action_color|%a"

export PAGER=less
export LESS="-iMSx4 -FXe -R"
export ESHELL=/bin/zsh
export EDITOR=/usr/bin/vim
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
export PATH=$PATH:/usr/local/bin

alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'

# no spelling correction
alias mv='nocorrect mv -i'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias ls='ls --color=auto'

# Set the window title in screen to the running program
exec_time="$SECONDS"

preexec () {
    if [[ $TERM[1,6] == 'screen' ]]; then
        #I don't know what this is
        local -a cmd
        local -a luser
        local -a args

        # 1 refers to the input string, while (z) is zsh's "split" function, I'm pretty sure
        args=(${(z)1})

        # We just want the first thing typed, aka the command
        if [[ $args[1] == "hg" || $args[1] == "sudo" || $args[1] == "git" ]]; then
	        cmd="$args[1] $args[2]"
        else
	        cmd="$args[1]"
        fi

        if [[ $SHLVL > 2 ]]; then
	        if [[ $UID == 0 ]]; then
	            luser="root"
	        else
	            luser=$USER
	        fi
	        cmd="$cmd ($luser)"
        fi
        echo -ne "\ek$(virt_screen)$cmd\e\\"
    fi

    exec_time="$SECONDS"
}

# Return the screen window title to the default when program finishes
precmd () {
    local -a luser
    local -a default

    if [[ $TERM[1,6] == 'screen' ]]; then
        if [[ $SHLVL > 2 ]]; then
	        if [[ $UID == 0 ]]; then
	            luser="root"
	        else
	            luser=$USER
	        fi
	        default="zsh ($luser)";
        else
	        default="zsh";
        fi
        echo -ne "\ek$(virt_screen)$default\e\\"
    fi
}

time_display () {
    local -a time_elapsed
    local -a seconds
    local -a minutes
    local -a hours
    local -a pad_seconds
    local -a pad_minutes
    local -a _time_display

    time_elapsed=$(( $SECONDS - $exec_time ))
    if [[ $time_elapsed > 2 ]]; then
        seconds=$(( $time_elapsed % 60 ))
        minutes=$(( int($time_elapsed / 60) % 60 ))
        hours=$(( int($time_elapsed / 60 / 60) ))

        pad_seconds=`printf "%02d" "$seconds"`

        if [[ $hours -gt 0 ]]; then
            pad_minutes=`printf "%02d" "$minutes"`
            _time_display="$hours:$pad_minutes:$pad_seconds "
        else
            if [[ $minutes -gt 0 ]]; then
                _time_display="$minutes:$pad_seconds "
            else
                _time_display=":$pad_seconds "
            fi
        fi
        echo "$time_color$_time_display"
    fi
}

virt_screen () {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        virt_name=`basename $VIRTUAL_ENV`
        echo "[$virt_name] "
    fi
}

virt_prompt () {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        virt_name=`basename $VIRTUAL_ENV`
        echo "$virt_color($virt_name) "
    fi
}

vcs_prompt () {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "$vcs_color$vcs_info_msg_0_%{$reset_color%}"
    fi
}

export PS1='
$userpart $tty_color%l $(time_display)%(?..$error_color %? $end_error_color)
$(virt_prompt)$prompt_color%#%{$reset_color%} '
export RPS1='$path_color%/%{$reset_color%} $(vcs_prompt)'

# load autocopmletions (poetry)
fpath+=~/.zfunc
autoload -Uz compinit && compinit



mkprojdirs (){
    mkdir ~/sites/$1
    cd ~/sites/$1
    mkdir proj
    mkdir src
    mkdir htdocs
    mkdir htdocs/static
    mkdir htdocs/media
    mkdir var
    mkdir var/log
    mkdir var/run
}
