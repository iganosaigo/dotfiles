# zsh theme
if [ $UID -eq 0 ]; then
  ROOTCHECK="%{$fg[red]%}%n%{$fg_bold[blue]%}@%m";
else
  ROOTCHECK="%{$fg[cyan]%}%n%{$fg_bold[blue]%}@%m";
fi

local return_code='%(?:%{$fg[cyan]%}➜ %{$reset_color%}:%{$fg[red]%}%? ↵%{$reset_color%})'
local user='$ROOTCHECK'

PROMPT="${return_code} ${user} "
PROMPT+='%{$fg[cyan]%}%c%{$fg[white]%}%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
