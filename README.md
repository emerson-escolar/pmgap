# pmgap
Some computations for Persistence Modules using GAP

This package is still in very alpha development. 
Features are incomplete, and the API is subject to extreme changes as deemed necessary.

# Install

## Part 1: GAP package pmgap

1. Install [GAP](https://www.gap-system.org/) and its packages, which already includes [QPA](https://www.gap-system.org/Packages/qpa.html).

2. Locate and choose a pkg directory where GAP searches for packages. See 
   Section 9.2 "GAP Root Directories" of the GAP manual for more information.
   
   It can be any pkg/ subdirectory of one of the directories returned by running:
   ```
   gap> GAPInfo.RootPaths;
   ```
   in gap. A typical choice is to use the directory `~/.gap/pkg/`.
   
3. Clone/download this repository as a subfolder in the pkg directory. 
   As an example, all the contents of this repository will be inside `~/.gap/pkg/pmgap-master`.
   Alternatively, a symbolic link can also be used.

4. Run tests by running
   ```
   >> gap tst/testall.g
   ```
   in the pmgap folder, inside the shell (outside of GAP).
   
5. Compile the documentation by running
   ```
   >> gap makedoc.g
   ```
   in the pmgap folder, inside the shell (outside of GAP).
   
6. Load the package with
   ```
   gap> LoadPackage("pmgap");
   ```
   inside of GAP. If installed correctly, this should work from any folder.

## Part 2: C++ utility scripts

0. Ensure that the following libraries are installed.

    - [Eigen](http://eigen.tuxfamily.org/index.php?title=Main_Page)
    - [nlohmann/json](https://github.com/nlohmann/json)
    - [TCLAP](http://tclap.sourceforge.net/)
    - [Catch2](https://github.com/catchorg/Catch2)
    - autoconf
    - automake
    - libtool
    
    The above requirements may be available using your operating system's package manager. For example, using apt on Ubuntu, the requirements may be satisifed by installing
    
    - libeigen3-dev
    - nlohmann-json3-dev
    - libtclap-dev
    - catch
    - autoconf
    - automake
    - libtool
    
    respectively. 
    
    This project used to depend on
    
    - [gyoza](https://bitbucket.org/remere/gyoza/src/master/)
    
    but this dependency has been removed. This project now directly contains code from gyoza.


1. Navigate to this project's folder (as set in step 3 above).

2. Run the following commands, making sure that the previous command succeeds before proceeding to the next one.
   ```
   autoreconf --install
   ```
   ```
   ./configure
   ```
   ```
   make
   ```
   ```
   make check
   ```
   ```
   make install
   ```


## TROUBLESHOOTING

1. `./configure` complains that "Eigen header not found".
    [SOLUTION] Try adding Eigen to CPPFLAGS as follows: 
    ```
    ./configure CPPFLAGS=-I/usr/include/eigen3
    ```
    or wherever you have installed Eigen.


# Usage
Refer to the documentation in the folder doc/ (after compiling the documentation).
