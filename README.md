GrandOrgue Compiler for Raspberry Pi
==============

Need GrandOrgue to power your portable setup? This is just what you need. GrandOrgue doesn't run easily on the Raspberry Pi. This bash script does the following, in an automated manner:

1. Gets the most recent version of the source code from GitHub (https://github.com/e9925248/grandorgue)
2. Instsalls the packages needed to compile (apt-get install ....)
3. Prepares sourcecode to compile (cmake)
4. Compiles the source code (make)

To use this bash script, please begin with a new install of Raspian, then run:

    wget https://git.io/vwgOA -O installGoAuto.sh
    chmod +x installGoAuto.sh
    sudo ./installGoAuto.sh
