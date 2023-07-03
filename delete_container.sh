#!/bin/bash
set -euxo pipefail

# List all container exited"
docker ps -a | grep "Exited" | awk '{print $1}' > temp.txt
# File container container id
file="temp.txt"
#Total line want to exclude
lines_to_exclude=10
#Total line in file
total_lines=$(wc -l < "$file")
#Total line want delete 
lines_to_delete=$((total_lines - lines_to_exclude))
# print lines want delete and delete it
head -n "$lines_to_delete" "$file" | xargs docker container rm
