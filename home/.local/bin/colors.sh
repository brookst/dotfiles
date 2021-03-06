#! /bin/bash

# Define colors
NO_COLOUR=$'\033[0m'
RED=$'\033[0;31m'
LIGHT_RED=$'\033[1;31m'
GREEN=$'\033[0;32m'
LIGHT_GREEN=$'\033[1;32m'
YELLOW=$'\033[0;33m'
LIGHT_YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
LIGHT_BLUE=$'\033[1;34m'
MAGENTA=$'\033[0;35m'
LIGHT_MAGENTA=$'\033[1;35m'
CYAN=$'\033[0;36m'
LIGHT_CYAN=$'\033[1;36m'
WHITE=$'\033[0;37m'
LIGHT_WHITE=$'\033[1;37m'

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval printf "%-9b%b%-12b" "${color}: " \$${color} "${color}\\ Foo"
    # eval echo -n \$${color}
    # echo -n "${color} Foo ${NO_COLOUR}LIGHT_${color}: "
    eval printf "%b%-15b%b%-18b" $NO_COLOUR "LIGHT_${color}: " \$LIGHT_${color} "LIGHT_${color}\\ Foo"
    # echo -n "LIGHT_${color} Foo"
    echo "${NO_COLOUR}"
done
