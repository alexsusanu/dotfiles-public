#!/bin/bash

# Create symlinks from current directory's hidden files to ~/
for file in .*; do 
  if [ -f "$file" ] && [ "$file" != "." ] && [ "$file" != ".." ]; then
    ln -sf "$(pwd)/$file" ~/"$file"
    echo "Created symlink: ~/$file -> $(pwd)/$file"
  fi
done