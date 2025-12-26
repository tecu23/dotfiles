# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias glog="git log --oneline --decorate --graph"

# Kubernetes aliases
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kdp="kubectl describe pod"
alias kl="kubectl logs"
alias klf="kubectl logs -f"

# Terraform aliases
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfv="terraform validate"
alias tff="terraform fmt"

# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias drm="docker rm"
alias drmi="docker rmi"
alias dprune="docker system prune -af"

# GCP aliases
alias gcl="gcloud"
alias gcp="gcloud config get-value project"
alias gcsp="gcloud config set project"

# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# List aliases
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# Utility aliases
alias c="clear"
alias h="history"
alias reload="source ~/.zshrc"
alias zshconfig="nvim ~/.zshrc"

# Safety aliases
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Modern CLI tools (if installed via Brewfile)
alias cat="bat"
alias find="fd"
alias grep="rg"
