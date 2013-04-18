PROMPT='%{$fg[yellow]%}%m %{$fg[green]%}%c $(virtualenv_info)$(git_prompt_info)%{$fg[yellow]%}
→ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}[%{$fg[blue]%}git %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%}] %{$reset_color%}"
ZSH_THEME_VE_PROMPT_PREFIX="%{$fg[yellow]%}[%{$fg[blue]%}venv %{$fg[red]%}"
ZSH_THEME_VE_PROMPT_SUFFIX="%{$fg[yellow]%}] %{$reset_color%}"