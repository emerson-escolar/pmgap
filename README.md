# pmgap
Some computations for Persistence Modules using GAP

This package is still in very alpha development. 
Features are incomplete, and the API is subject to extreme changes as deemed necessary.

# Install

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


# Usage
Refer to the documentation in the folder doc/ (after compiling the documentation).
