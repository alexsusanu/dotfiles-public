#!/bin/bash

# Script to clean up filenames in current directory
# - Removes single quotes (')
# - Removes double quotes (")
# - Replaces spaces with underscores (_)
# - Converts to lowercase
# - Removes other problematic characters

echo "Cleaning filenames in current directory..."

for file in *; do
    # Skip if it's a directory or this script
    if [[ -d "$file" ]] || [[ "$file" == "clean_filenames.sh" ]]; then
        continue
    fi
    
    # Get the original filename
    original="$file"
    
    # Clean the filename:
    # 1. Remove single and double quotes
    # 2. Replace spaces with underscores
    # 3. Convert to lowercase
    # 4. Remove other problematic characters like (), [], {}
    cleaned=$(echo "$file" | \
        sed "s/['\"]//g" | \
        sed 's/ /_/g' | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/[(){}[\]]//g' | \
        sed 's/[&]/_and_/g' | \
        sed 's/__*/_/g' | \
        sed 's/^_\|_$//g')
    
    # Only rename if the name actually changed
    if [[ "$original" != "$cleaned" ]]; then
        # Check if target filename already exists
        if [[ -e "$cleaned" ]]; then
            echo "Warning: $cleaned already exists, skipping $original"
        else
            # Handle case-insensitive filesystems by using temp name
            temp_name="tmp_$$_$(basename "$original")"
            mv "$original" "$temp_name" && mv "$temp_name" "$cleaned"
            echo "Renamed: '$original' -> '$cleaned'"
        fi
    fi
done

echo "Done cleaning filenames!"