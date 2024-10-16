# If you come from bash you might have to change your $PATH.
export ZSH=$HOME/.oh-my-zsh
export GOPATH=$(go env GOPATH)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="lambda"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm)

source $ZSH/oh-my-zsh.sh


# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH=~/.ssh/id_ed25519

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias source-zshrc='source ~/.zshrc'
alias szrc=source-zshrc
alias edit-zshrc='vim ~/.zshrc'
alias ezrc=edit-zshrc

alias edit-git-config='vim ~/.gitconfig'
alias edit-gitconfig=edit-git-config
alias egcf=edit-git-config

alias j=jrnl
alias g=git
alias k=kubectl
alias tf=terraform
alias watch='watch ' # allows "watch" to expand another alias (e.g. watch k get po --all-namespaces)
alias tree='tree -S'

# Custom Environment Variables
export EDITOR=vim

# Generators for languages are in various
function available_generator_functions() {
  cat $HOME/.*-shellrc | grep '^\w*function gen::.*()' | sed -e 's/function //g' -e 's/() {//g'
}
alias agf='available_generator_functions'

# autocompletion
if test -f /usr/local/share/zsh/site-functions/aws_zsh_completer.sh; then
  source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
fi
source <(kubectl completion zsh)
complete -F __start_kubectl k # get k8s autocompletion working with "k" alias
# for aws
complete -C "$(which aws_completer)" aws

# export KUBECONFIG=$HOME/pi-cluster-config:$HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# export PATH=~/Library/Python/2.7/bin:$PATH
# for pyenv
# export PATH="$(pyenv root)/shims:${PATH}"
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export PATH="~/go/bin:${PATH}"
export PATH=/usr/local/bin:$PATH
export PAth=/usr/local/opt:$PATH
export PATH=~/bin:$PATH
export PATH="${PATH}":~/Library/Python/3.9/lib/python/site-packages
export PATH="${PATH}":"/Users/${USER}/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.amplify/bin:$PATH"

# <3 tmux
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
	if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	  exec tmux
	fi
fi


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# ssh-add run without arguments adds in default public keys
ssh-add

# I have language specific rc files (e.g. ~/.git-shellrc, ~/.node-shellrc, ~/.go-shellrc) where language specific configuration (and/or generate fns shell fns) exist
# shellrc_files=$(~/.*-shellrc 2> /dev/null)
# if [ -n shellrc_files ]; then
  # for shellrc in $shellrc_files; do
    # . $shellrc
  # done
# fi

export NVM_DIR="$HOME/.nvm"
mkdir -p "${NVM_DIR}"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# for aws autocompletion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
eval "$(gh copilot alias -- zsh)"
