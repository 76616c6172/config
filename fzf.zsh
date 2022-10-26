# REQUIRED BY FZF
# #
# IMPORTANT !!
# path to configuration files in here has to be specified as absolute!!
# #
# Setup fzf
# ---------
if [[ ! "$PATH" == */home/valar/projects/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/valar/projects/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/valar/configuration/fzf/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/valar/.configuration/fzf/key-bindings.zsh"
