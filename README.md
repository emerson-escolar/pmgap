# pmgap
Computations for Persistence Modules using GAP

This package is still in alpha development. 
Features are incomplete, and the API is subject to changes as deemed necessary.

# What can it do?

Currently, the following main features are implemented.

1. Objects representing persistence modules over finite commutative grids and functions to work with them. 
   * Creation of commutative grids and persistence modules
   * Reading and writing files that represent persistence modules
   * Enumeration of interval persistence modules
   
2. Computation of the interval-decomposable part of a persistence module, using the algorithm in **H. Asashiba, M. Buchet, E. G. Escolar, K. Nakashima, and M. Yoshiwaki. "On Interval Decomposability of 2D Persistence Modules". [arXiv:1812.05261](https://arxiv.org/abs/1812.05261)**. 
   These computations can be performed within GAP, or using the convenience scripts:
   ```
   pmgap_interval_decomposable.sh
   ```
   and
   ```
   pmgap_batch_interval_decomposable.sh
   ```
   provided (installation of utility scripts needed).

3. Computation of the compressed multiplicity and interval-decomposable approximation over 2 x n grids, as introduced in **H. Asashiba, E. G. Escolar, K. Nakashima, and M. Yoshiwaki. "On Approximation of 2D Persistence Modules by Interval-decomposables". [arXiv:1911.01637](https://arxiv.org/abs/1911.01637)**
   These computations can be performed within GAP, or using the convenience script:
   ```
   pmgap_interval_approximation.sh
   ``` 
   provided (installation of utility scripts needed).
   
4. Creation of persistence module over finite finite commutative grid from a bifiltered simplicial complex, using the program
   ```
   pmgap_cmplx2repn
   ```
   (compilation and installation of utility scripts needed).
   
# Demos 
1. Demo for the paper **[On Approximation of 2D Persistence Modules by Interval-decomposables](https://arxiv.org/abs/1911.01637)** (compressed multiplicity and interval-decomposable approximation):

    After completing **Install Part 1: GAP package pmgap** below, navigate to the demos folder inside a terminal and run
    ```
    gap pmgap_demo_interval_approximation.g
    ```
    to run the demo.


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

## Part 2: utility scripts

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
    
    This project used to depend on [gyoza](https://bitbucket.org/remere/gyoza/src/master/), but this dependency has been removed. This project now directly contains code from gyoza.


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

2. Shared library not found when running c++ utilities.
   [SOLUTION] Try running
   ```
   sudo ldconfig
   ```
   See also https://stackoverflow.com/questions/480764/linux-error-while-loading-shared-libraries-cannot-open-shared-object-file-no-s
   
3. `make install` gives "Permission denied" error.
   [SOLUTION] Install as 
   ```
   sudo make install
   ```
   or use `--prefix` option with `./configure` in order to change the installation directory.
   See
   ```
   ./configure --help
   ```
   for more details.
   

# Usage
Refer to the documentation in the folder doc/ (after compiling the documentation).
