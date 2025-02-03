if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Add rbenv to bash so that it loads automatically
eval "$(rbenv init -)"
eval "$(zoxide init --cmd cd zsh)"

# aliases:
alias grtp="git add . && git commit -m"
alias tfmt="terraform fmt"
alias tfmte="terraform fmt env/prod"
alias gfmt="gofmt -w main.go"
alias gstm="git switch main && git pull"
alias rmlb='git branch --l | grep -v \* | xargs git branch -D'
alias gstnb="git switch -c"
alias gstb="git switch"
alias n="nvim ."
alias ls='lsd --icon always --color always'
alias ipam='$HOME/Documents/workspace-ter/test/ipam.sh'
alias grun='go run main.go'

# install precommit
function preYeet {
    cp $HOME/Documents/gointro-ter/.pre-commit-config.yaml .

    pre-commit install

    echo -e "\n.pre-commit-config.yaml" >> .gitignore
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# cdd searches for git repo:
function cdd {
    cd
    # Find Git repositories in specified paths
    repos=$(fd -t d -H -I -g '*.git' .config kjerneplattform Documents | sed 's|/\.git\/$||')

    # Use fzf for selection, enforcing single selection
    selected_repo=$(echo "$repos" | fzf --height 40% --reverse --border --exit-0 --no-multi --preview 'lsd --icon always --color always {}')

    # Check if a repo was selected
    if [ -n "$selected_repo" ]; then
        cd "$selected_repo" || { echo "Failed to change directory to: $selected_repo"; exit 1; }
    else
        echo "No repository selected."
    fi
}

# push to confluence-push
function wiki {
    DEBUG=1 CONFLUENCE_PAT=your_pat_here C_FILE="$1" C_PAGE_TITLE="If you belive it hard enough, it may work..." ~/Documents/workspace-ter/con-infoblx-script/confluence-push.sh
}

# Finds sp from azure
function sp(){
    local temp_dir="$HOME/temp"
    local file_path="$temp_dir/sp.txt"

    # Create the temp directory if it doesn't exist
    if [[ ! -d "$temp_dir" ]]; then
        mkdir -p "$temp_dir" || { echo "Failed to create directory: $temp_dir"; return 1; }
    fi

    # Handle the "--update" argument
    if [[ "$1" == "--update" ]]; then
        az login
        az ad sp list --all --query '[].{Name:displayName, AppId:appId}' --output table > "$file_path"
        echo "Service Principals list updated."
        return 0
    fi

    # Ensure the file exists before proceeding
    if [[ ! -f "$file_path" ]]; then
        echo "File $file_path not found. Run 'sp --update' to create it."
        return 1
    fi

    # Handle the "--id" argument
    if [[ "$1" == "--id" ]]; then
        # Preview ID and output the selection
        selected_id=$(awk '{print $NF}' "$file_path" | \
            fzf --height 40% --reverse --border --exit-0 --no-multi \
            --preview "grep -F {} \"$file_path\" | awk -F'  +' '{print \$1}'")
        output=$(cat "$file_path" | grep "$selected_id" | awk -F'  +' '{print $1}')
        echo "Selected ID: $output"

    # Handle the "--name" argument
    elif [[ "$1" == "--name" ]]; then
        # Preview Name and output the selection
        selected_name=$(awk -F'  +' '{print $1}' "$file_path" | \
            fzf --height 40% --reverse --border --exit-0 --no-multi \
            --preview "grep -F {} \"$file_path\" | awk '{print \$NF}'")
        output=$(cat "$file_path" | grep "$selected_name" | awk '{print $NF}')
        echo "Selected Name: $output"

    else
        echo "Usage:"
        echo "  sp --update   # Update Service Principals list"
        echo "  sp --name     # Search for Service Principal by name"
        echo "  sp --id       # Search for Service Principal by ID"
    fi
}

