# Windows default screenshot and video functions for WSL
# Use Win+Shift+S for screenshots, Win+G for recordings

get_screenshot_path() {
    local win_screenshots="/mnt/c/Users/$(whoami)/Pictures/Screenshots"
    
    local latest_screenshot=$(
        cd "$win_screenshots" && ls -1t *.png 2>/dev/null | head -n 1
    )
    
    if [[ -n "$latest_screenshot" ]]; then
        local full_path="$win_screenshots/$latest_screenshot"
        echo -n "$full_path" | clip.exe
        echo "Path copied: $full_path"
    else
        echo "No screenshots found"
    fi
}

get_recording_path() {
    local win_recordings="/mnt/c/Users/$(whoami)/Videos/Captures"
    
    local latest_recording=$(
        cd "$win_recordings" && ls -1t *.{mp4,avi,mkv} 2>/dev/null | head -n 1
    )
    
    if [[ -n "$latest_recording" ]]; then
        local full_path="$win_recordings/$latest_recording"
        echo -n "$full_path" | clip.exe
        echo "Path copied: $full_path"
    else
        echo "No recordings found"
    fi
}

# Short aliases
alias sspath='get_screenshot_path'
alias recpath='get_recording_path'

# Usage:
# 1. Win+Shift+S for screenshot, then run: sspath
# 2. Win+G for recording, then run: recpath