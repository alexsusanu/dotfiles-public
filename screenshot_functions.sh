# Windows default screenshot and video functions for WSL
# Use Win+Shift+S for screenshots, Win+G for recordings

get_screenshot_path() {
    # Windows default Screenshots folder path in WSL
    local win_screenshots="/mnt/c/Users/$(whoami)/Pictures/Screenshots"
    
    # Find the most recent image file
    local latest_screenshot=$(find "$win_screenshots" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" 2>/dev/null | xargs ls -t | head -n 1)
    
    if [[ -n "$latest_screenshot" ]]; then
        # Copy path to clipboard
        echo "$latest_screenshot" | clip.exe
        echo "Latest screenshot path copied to clipboard:"
        echo "$latest_screenshot"
    else
        echo "No screenshots found in $win_screenshots"
    fi
}

get_recording_path() {
    # Windows default Videos/Captures folder (Xbox Game Bar recordings)
    local win_recordings="/mnt/c/Users/$(whoami)/Videos/Captures"
    
    # Find the most recent video file
    local latest_recording=$(find "$win_recordings" -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" 2>/dev/null | xargs ls -t | head -n 1)
    
    if [[ -n "$latest_recording" ]]; then
        # Copy path to clipboard
        echo "$latest_recording" | clip.exe
        echo "Latest recording path copied to clipboard:"
        echo "$latest_recording"
    else
        echo "No recordings found in $win_recordings"
        echo "Make sure to use Win+G to record videos"
    fi
}

# Short aliases
alias sspath='get_screenshot_path'
alias recpath='get_recording_path'

# Usage:
# 1. Win+Shift+S for screenshot, then run: sspath
# 2. Win+G for recording, then run: recpath