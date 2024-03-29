#!/usr/bin/env zsh

[ ! -n "${CDHOOK_USE_SET_GOLANG_CDPATH+1}"  ] && CDHOOK_USE_SET_GOLANG_CDPATH=true
[ ! -n "${CDHOOK_USE_SET_GIT_USER+1}" ] && CDHOOK_USE_SET_GIT_USER=true
BASE_CDPATH=$CDPATH

_set_golang_cdpath() {
    if [[ $CDHOOK_USE_SET_GOLANG_CDPATH == false ]]; then
        return
    fi
    local set_golang_cdpath="$(git config --get golang.cdpath 2>/dev/null)"

    if [[ -n "$set_golang_cdpath" ]] && [[ $set_golang_cdpath -gt 0 ]]; then
        local gitdir="$(git rev-parse --git-dir 2>/dev/null)"
        if [[ -n "$gitdir" ]]; then
            gitdir="$gitdir:A" # absolute path of $gitdir
            gitdir=$(dirname "$gitdir")
            export CDPATH=$gitdir/vendor
            if [[ -n "$BASE_CDPATH" ]]; then
                export CDPATH=$CDPATH:$BASE_CDPATH
            fi
        else
            export CDPATH=$BASE_CDPATH
        fi
    else
        export CDPATH=$BASE_CDPATH
    fi
}

_set_git_user() {
    if [[ $CDHOOK_USE_SET_GIT_USER == false ]]; then
        return
    fi
    local remote="$(git remote get-url origin 2>/dev/null)"
    if [[ -n "$remote" ]] && [[ -n "$CDHOOK_GIT_MATCH_URL" ]]; then
        if test "${remote#*$CDHOOK_GIT_MATCH_URL}" != "$remote"; then
            if [[ -n "$CDHOOK_GIT_MATCH_USER" ]] && [[ -n "$CDHOOK_GIT_MATCH_EMAIL" ]]; then
                git config user.name $CDHOOK_GIT_MATCH_USER
                git config user.email $CDHOOK_GIT_MATCH_EMAIL
                export FT_VIM_AUTHOR=$CDHOOK_GIT_MATCH_USER
                export FT_VIM_EMAIL=$CDHOOK_GIT_MATCH_EMAIL
            fi
        else
            if [[ -n "$CDHOOK_GIT_OTHER_USER" ]] && [[ -n "$CDHOOK_GIT_OTHER_EMAIL" ]]; then
                git config user.name $CDHOOK_GIT_OTHER_USER
                git config user.email $CDHOOK_GIT_OTHER_EMAIL
                export FT_VIM_AUTHOR=$CDHOOK_GIT_OTHER_USER
                export FT_VIM_EMAIL=$CDHOOK_GIT_OTHER_EMAIL
            fi
        fi
    fi
}

_set_ft_vim() {
    local remote="$(git remote get-url origin 2>/dev/null)"
    if [[ -n "$remote" ]] && [[ -n "$CDHOOK_FT_VIM_MATCH_URL" ]] && [[ "$remote" =~ "$CDHOOK_FT_VIM_MATCH_URL" ]]; then
        export FT_VIM_AUTHOR=$CDHOOK_FT_VIM_MATCH_AUTHOR
        export FT_VIM_EMAIL=$CDHOOK_FT_VIM_MATCH_EMAIL
    else
        export FT_VIM_AUTHOR=$CDHOOK_FT_VIM_OTHER_AUTHOR
        export FT_VIM_EMAIL=$CDHOOK_FT_VIM_OTHER_EMAIL
    fi
}

_cd_hook_chpwd_handler () {
    emulate -L zsh
    _set_golang_cdpath
    _set_git_user
    _set_ft_vim
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _cd_hook_chpwd_handler
_cd_hook_chpwd_handler
