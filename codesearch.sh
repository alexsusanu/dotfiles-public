# Code search function for current directory and subdirectories
# Add this to your .bashrc

codesearch() {
    if [[ -z "$1" ]]; then
        echo "Usage: codesearch <search_term>"
        return 1
    fi
    
    # Find files containing the search term in current directory and subdirectories
    local files=$(grep -r -l "$1" . 2>/dev/null | grep -v ".git/")
    
    if [[ -z "$files" ]]; then
        echo "No files found containing: $1"
        return 1
    fi
    
    # Use fzf to pick which file, with preview showing search matches
    local selected=$(echo "$files" | fzf --preview "rg --color=always -n -C 3 '$1' {}" --bind 'ctrl-u:preview-page-up,ctrl-d:preview-page-down' --with-nth=-1 --delimiter='/')
    [[ -n "$selected" ]] && vim "$selected"
}