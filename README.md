# Make MakeFile (mmf)
___

Shell script for bash that auto-generates a simple c/c++ Makefile in the current working directory having all the header and implementation [.h/.cpp] files in the same folder and not in sub-folders. The script can also compile the executable with the maximum amount of threads in a system. 

![mmf Demo](https://github.com/nikolaizombie1/mmf/blob/e4410dbda2054be33ba3b1e8c97e77de882e4564/mmf%20Demo.png?raw=true)
___

## Prerequisites packages

___

> automake autoconf bash

___

## Installation

You need to make the script executable with the command:

``` sh
 chmod 744 mmf
```

___

## Usage

If the script is in the current working Directory

``` sh
    ./mmf
```

If the script is in the shell path

``` sh
    mmf
```

