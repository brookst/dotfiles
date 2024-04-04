#!/usr/bin/env bash

NO_COLOUR=$'\033[0m'
RED=$'\033[0;31m'

logger () {
    while read line; do
        echo "    $line"
    done
}

echo "#$(date)" > bundle.list
while read repo; do
    pushd "$repo" > /dev/null
    url=""
    for remote in $(git remote -v | grep fetch | awk '{print $1}'); do
        url=$(git remote -v | grep -e "^${remote}" | grep fetch | awk '{print $2}')
        echo "${repo}: ${url}"
        if [ "$remote" == "origin" ]; then
            git pull "${remote}" master |& logger
        else
            echo "${RED}Not updating from remote ${remote}${NO_COLOUR}"
        fi
    done
    popd > /dev/null
    echo "${url}" >> bundle.list
done < <(find * -maxdepth 0 -type d)

# Generate helptags
if which nvim > /dev/null; then
    nvim -c 'call pathogen#helptags()' -c 'q' > /dev/null
else
    vim -c 'call pathogen#helptags()' -c 'q' > /dev/null
fi
