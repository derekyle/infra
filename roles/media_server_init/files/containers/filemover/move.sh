#!/bin/ash
# get full path to oldest file in given directory

# Directories this script creates on the destination must be world-writable and
# owned by 1000:1000 so the *arr apps (uid 1000) can later rename/hardlink/delete
# files inside them. This container runs as root; without this, mkdir -p leaves
# root:root 0755 dirs that break Sonarr/Radarr imports through mergerfs.
umask 000
owner="1000:1000"

let size_limit="SIZE_LIMIT * 1024 * 1024"
echo "limit: $size_limit"
let target_size="TARGET_SIZE * 1024 * 1024"
echo "target: $target_size"
echo "current: $(du -s '/storage-fast' | cut -f1)"

source_directory="/storage-fast"
target_directory="/storage-slow"

folder_size () {
    du -s "/storage-fast" | cut -f1
}

get_oldest_file () {
    find "$source_directory" -type f -exec stat -c "%Y %n" {} + | sort | head -n 1
}


# find and replace from the beginning of a given string
get_new_path () {
    echo "$1" | sed "s|^$source_directory|$target_directory|"
}

# walk every directory level from "$1" up to (but not including) $target_directory
# and normalise ownership/permissions, fixing whatever mkdir -p just created as root
fix_dir_perms () {
    d="$1"
    while [ -n "$d" ] && [ "$d" != "$target_directory" ] && [ "$d" != "/" ]; do
        chown "$owner" "$d" 2>/dev/null
        chmod 777 "$d" 2>/dev/null
        d=$(dirname "$d")
    done
}

while true
do


  while [ $(folder_size) -gt $target_size ]; do

      oldest_file=$(get_oldest_file)
      oldest_file_full_path=$(echo "$oldest_file" | cut -d' ' -f2-)
      oldest_file_dir=$(dirname "$oldest_file_full_path")


      new_file_full_path=$(get_new_path "$oldest_file_full_path")
      new_file_dir=$(get_new_path "$oldest_file_dir")

      mkdir -p "$new_file_dir"
      fix_dir_perms "$new_file_dir"
      rsync -av --chown="$owner" --chmod=D777,F666 --remove-source-files "$oldest_file_full_path" "$new_file_full_path"
      echo moved "$oldest_file_full_path" "$new_file_full_path"
  done

  sleep 30

done