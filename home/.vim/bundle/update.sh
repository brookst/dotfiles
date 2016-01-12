#!/bin/bash

echo "#$(date)" > update.list
for repo in $(find * -maxdepth 0 -type d); do
    cd "$repo"
    url=""
    for remote in $(git remote -v | grep fetch | awk '{print $1}'); do
        url=$(git remote -v | grep -e "^${remote}" | grep fetch | awk '{print $2}')
        echo "${repo}: ${url}"
        if [ "$remote" == "origin" ]; then
            git pull "${remote}" master
        else
            echo "Not updateing from remote ${remote}"
        fi
    done
    cd ..
    echo "${url}" >> update.list
done

vim -RET dumb -c 'Helptags' -c 'q' > /dev/null
