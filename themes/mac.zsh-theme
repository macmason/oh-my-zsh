# Non-bold colors.
RESET_COLOR="%{$reset_color%}"
GREEN="%{$fg[green]%}"
RED="%{$fg[red]%}"
CYAN="%{$fg[cyan]%}"
YELLOW="%{$fg[yellow]%}"
BLUE="%{$fg[blue]%}"
MAGENTA="%{$fg[magenta]%}"
WHITE="%{$fg[white]%}"

# Set up how we present git status.
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$RESET_COLOR"

# Lifted from fishy.zsh-theme, because this is cool.
_fishy_collapsed_wd() {
  echo $(echo $1 | perl -pe "
   BEGIN {
      binmode STDIN,  ':encoding(UTF-8)';
      binmode STDOUT, ':encoding(UTF-8)';
   }; s|^$HOME|~|g; s|/([^/])[^/]*(?=/)|/\$1|g;
")
}

# For tracking CITC client state.
CITC_ROOT=/google/src/cloud/jmason
_citc_helper() {
  # This will have ~CITC_ROOT on the front, because of a weird sub.
  # This == thing turns off word splitting.
  local path_prompt="${==$(print -P '%~')}"
  # So take that off.
  echo ${path_prompt##"~CITC_ROOT/"}
}

_mac_lprompt() {
  local upperl="╭─"
  local lowerl="╰─"
  local prenewline="["
  local newline="\n"
  local postnewline="]"
  local pathstring="~"
  # Am I doing a path or a CITC?
  local citc=${=="$(_citc_helper)"}

  # Don't print two lines if I'm in ~
  if [[ $(print -P "%~") == "~" ]]; then
    upperl=""
    lowerl=""
    prenewline=""
    newline=""
    postnewline=""
  else
    # I'm in a regular directory
    pathstring=$(_fishy_collapsed_wd $PWD)
  fi
  echo "$upperl$prenewline$pathstring$postnewline$newline$lowerl%# "
}

_mac_rprompt() {
  local git_root_dir=""
  # If I'm in my homedir.
  if [[ $(print -P "%~") == "~" ]]; then
    git_root_dir="~"
  else
    git_root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ "$git_root_dir" == "$HOME" ]]; then
      git_root_dir="~"
    elif [[ "$git_root_dir" != "" ]]; then
      git_root_dir=$(basename $git_root_dir)
    fi
  fi

  local git_string=""
  if [[ $(parse_git_dirty) != "" ]]; then
    git_string="$RED$git_root_dir:$(git_prompt_info)$RESET_COLOR|"
  else
    git_string="$git_root_dir:$(git_prompt_info)$RESET_COLOR|"
  fi
  local ros_string=""
  if [[ "$ROS_DISTRO" != "" ]]; then
    ros_string="$GREEN$ROS_DISTRO$RESET_COLOR|"
  fi
  echo "[""$git_string$ros_string$BLUE%m$RESET_COLOR""]"
}

PROMPT='$(_mac_lprompt)'
RPROMPT='$(_mac_rprompt)'
