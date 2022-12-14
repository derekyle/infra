#!/bin/bash
# get full path to oldest file in given directory
size_limit=750000000 # 750GB

target_size=700000000 # 700GB

source_directory="/storage-fast"
target_directory="/storage-slow"

folder_size () {
    du -s "/storage-fast" | cut -f1
}

get_oldest_file () {
    find "$source_directory" -type f -printf '%C+\t%p\t%h\n' | sort | head -n 1
}

# find and replace from the beginning of a given string
get_new_path () {
    echo "$1" | sed "s|^$source_directory|$target_directory|"
}

while [ $(folder_size) -gt $target_size ]; do

    oldest_file=$(get_oldest_file)
    oldest_file_full=$(echo "$oldest_file" | cut -f2)
    oldest_file_dir=$(echo "$oldest_file" | cut -f3)

    new_file_full=$(get_new_path "$oldest_file_full")
    new_file_dir=$(get_new_path "$oldest_file_dir")

    mkdir -p "$new_file_dir"
    rsync -av --remove-source-files "$oldest_file_full" "$new_file_full"
    echo moved "$oldest_file_full" "$new_file_full"
done
