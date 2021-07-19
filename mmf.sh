#!/bin/bash

# Author: Fabio J. Matos Nieves
# Date Created: 18/7/2021
# Last Modified: 19/7/2021

# Description
# This script creates a c/c++ MakeFile in the current working directory having the main located in a main.cpp file

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

read -p "Would you like proceed to generating the Makefile? [y/n]: " yn
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

for outputfile in $(cat cpps.txt); do
    echo "$outputfile.o" >> outputfile.txt
done

readarray -t outputarray < outputfile.txt

echo -en "output: " >> Makefile
echo -en "${outputarray[@]}" >> Makefile
echo  "" >> Makefile
echo -en "\tg++ " >> Makefile
echo -en "${outputarray[@]}" >> Makefile
echo -en " -o executable" >> Makefile
echo "" >> Makefile
echo "" >> Makefile

for line in $(cat cpps.txt); do
    if [ "$line" = "$(cat hs.txt | grep "$line")" ]; then
        echo "" >> Makefile
        echo -en "$line.o: $line.cpp $line.h" >> Makefile
        echo "" >> Makefile
        echo -en "\tg++ -c $line.cpp" >> Makefile
        echo "" >> Makefile
    else
        echo -en "$line.o: $line.cpp" >> Makefile
        echo "" >> Makefile
        echo -en "\tg++ -c $line.cpp" >> Makefile
        echo "" >> Makefile
    fi
done

echo "" >> Makefile
echo "clean:" >> Makefile
echo -e "\trm *.o executable" >> Makefile

cat Makefile
rm cpps.txt outputfile.txt hs.txt
echo ""
echo ""
echo "Makefile Generated"
