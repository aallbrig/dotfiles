# .profile - POSIX-compliant environment variables
# Sourced by login shells (sh, bash, zsh)

# Editor configuration
export EDITOR=vim

# SSH configuration
export SSH_KEY_PATH=~/.ssh/id_ed25519

# Colors for ls
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Kubernetes configuration
export KUBECONFIG="$HOME/.kube/config"

# Go configuration
GOPATH=$(go env GOPATH 2>/dev/null || echo "$HOME/go")
export GOPATH

# PATH modifications
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="${PATH}:$HOME/Library/Python/3.9/lib/python/site-packages"
export PATH="${PATH}:/Users/${USER}/Library/Application Support/JetBrains/Toolbox/scripts"
GOBIN_PATH=$(go env GOPATH 2>/dev/null || echo "$HOME/go")/bin
export PATH="$PATH:$GOBIN_PATH"
export PATH="$HOME/.amplify/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# NVM directory (declare here, initialization happens in shell-specific rc)
export NVM_DIR="$HOME/.nvm"
