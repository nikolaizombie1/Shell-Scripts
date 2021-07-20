#!/bin/bash

# Author: Fabio J. Matos Nieves
# Date Created: 18/7/2021
# Last Modified: 19/7/2021

# Description
# This script creates a c/c++ MakeFile in the current working directory having the main located in a main.cpp file. Note: The the header and implementation files should all be in the same folder.

# Usage
# ./mmf.sh

echo "Hello, this script will now read all the .cpp and .h files within this directory and its subdirectories"
read -rp "Would you like to proceed? [y/n]: " yn
if [ "$yn" != y ]; then
    echo "Script Closed"
    exit 1
fi

echo "Script Proceeding"
echo ""
readarray -t cpps < <(find "$PWD" -type f -name '*.cpp' | rev | cut -d '/' -f 1 | rev)
readarray -t hs < <(find "$PWD" -type f -name '*.h' | rev | cut -d '/' -f 1 | rev)
echo  "These are the .cpp files that will be compiled: "
echo "${cpps[@]}"
echo ""
echo  "These are the .h files that will be compiled: "
echo "${hs[@]}"
echo ""

read -rp "Would you like proceed to generating the Makefile? [y/n]: " yn
echo ""

if [ "$yn" != y ]; then
    echo "Script Closed"
    exit 1
fi

if [ -f Makefile ]; then
    rm Makefile
fi

if [ -f cpps.txt ]; then
    rm cpps.txt
fi

if [ -f hs.txt ]; then
    rm hs.txt
fi

if [ -f outputfile.txt ]; then
    rm outputfile.txt
fi

echo "${cpps[@]}" | tr ' ' '\n' | cut -d '.' -f 1 > cpps.txt
echo "${hs[@]}" | tr ' ' '\n' | cut -d '.' -f 1 > hs.txt

while read -r outputfile; do
    echo "$outputfile.o" >> outputfile.txt
done < cpps.txt

readarray -t outputarray < outputfile.txt

output=$(echo -en "output: " ; echo -en "${outputarray[@]}" ; echo -en "\n" ; echo -en "\tg++ " ; echo -en "${outputarray[@]}" ; echo -en " -o executable" ; echo "")
echo "$output " >> Makefile

while read -r line; do
    if [ "$line" = "$(grep "$line" < hs.txt)" ]; then
        output=$(echo -en "\n" ; echo -en "$line.o: $line.cpp $line.h" ; echo "" ; echo -en "\tg++ -c $line.cpp" ; echo -e "\n")
        echo "$output" >> Makefile
    else
        output=$(echo -en "\n" ; echo -en "$line.o: $line.cpp" ; echo "" ; echo -en "\tg++ -c $line.cpp" ; echo "")
        echo "$output" >> Makefile
    fi
done < cpps.txt

output=$(echo "" ; echo "clean:" ; echo -e "\trm *.o executable")
echo "$output" >> Makefile

cat Makefile
rm cpps.txt outputfile.txt hs.txt
echo ""
echo "Makefile Generated"

read -rp "Would you like to compile the executable? [y/n]: " yn
if [ "$yn" != y ]; then
    echo "Script Closed"
    exit 0
else
    make "-j$(nproc)"
fi
