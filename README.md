PROJECT ARCHIVED
==============

This project is no longer maintained. However, one promising fork is found at https://github.com/djbottrill/GrandOrguePi


GrandOrgue Compiler Script for Raspberry Pi
==============

Need GrandOrgue to power your portable setup? GrandOrgue doesn't have native binaries for the Raspberry Pi, and compiling your own is a pain. Not with this automated script! This bash script does the following:

1. Gets the most recent version of the source code from GitHub ([Repository here](https://github.com/e9925248/grandorgue))
2. Installs the packages needed for compiling (apt-get install ....)
3. Prepares sourcecode to compile (cmake)
4. Compiles the source code (make)

To use this bash script, please begin with a new install of Raspian, and ensure it is connected to the internet. Once that is complete, run the bash script provided here using this single command:
````
wget https://git.io/vwgOA -O installGoAuto.sh && chmod +x installGoAuto.sh && sudo ./installGoAuto.sh
````
Miscellany
------------
* The initial prep process can take 10-20 minutes, and the compiling process itself can take an hour or more.
* This has been tested on the Raspberry Pi 3. No tests on the slower Pi 2 and 1 have been done at this time.
* The only midi interface I own ([LINK] (http://amzn.to/1TanhaX)) worked perfectly as soon as I plugged in. YMMV with other interfaces.
* The built in Raspberry Pi soundcard is not very high quality. I highly suggest getting a higher quality soundcard if you plan to use this for more than practice. Again, YMMV.

Suggested Settings
-------------

There are a number of things which are not required for Grand Orgue to work, but are reccomended:
* Run "sudo raspi-config" and ensure that audio is forced through the soundcard, not the HDMI.
