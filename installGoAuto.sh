v#!/bin/bash

########################
# GrandOrgue installer for Raspberry Pi
#
# Created by Ben Yanke
# ben@benyanke.com
#
# Last modified 4/23/2016
########################


########################
# Functions
########################

#neither of thes eused right now

# line counter for steps

step() { sed 's/^/[] /'; }
subStep() { sed 's/^/      /'; }

stepStatus() {
	if [ $1=="1" ]; then
		echo "Success";
	else
		echo "Fail";
	fi
}

########################
# Main
########################

# check if running root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit 1
fi

clear;

fullPath=$(pwd)


#start comment
#: '

echo ;
echo "GRANDORGUE INSTALLER FOR RASPBERRY PI";
echo ;
echo "This has been tested on the Pi3";
echo "running a clean Raspian Jesse install (03-18-2016 build).";
echo ;
echo "Use at your own risk elsewhere.";
echo ;
echo "########################"
echo ;


echo "Updating package repository" | step
apt-get update -y  > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "Could not update packages." | subStep
	exit 1
fi

mkdir -p $fullPath/goSrc

if [ $? -ne 0 ]; then
	echo "Directories could not be created." | subStep
	exit 1
fi

mkdir -p $fullPath/goBuild

if [ $? -ne 0 ]; then
	echo "Directories could not be created." | subStep
	exit 1
fi


echo "Getting most recent version of source code from github." | step
/usr/bin/git clone https://github.com/e9925248/grandorgue.git $fullPath/goSrc/  > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "Github sources already present. Updating them to most recent version." | subStep
	/usr/bin/git -C $fullPath/goSrc pull  > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Github retrevial failed." | subStep
		exit 1
	else
		echo "Update completed." | subStep
	fi
fi

echo "Installing needed packages." | step

instPackages() {
#	apt-get install -y jackd2 > /dev/null 2>&1
#	apt-get install -y jackd1 > /dev/null 2>&1
	apt-get install -y gcc make cmake jack docbook-xsl xsltproc zip gettext po4a python-wxgtk2.8 python-wxglade libwxgtk2.8-dev wxWid* libjack-jackd2-dev libasound2-dev libwxgtk2.8-dev > /dev/null 2>&1
	apt-get install -y libusb-1.0-0-dev > /dev/null 2>&1
	apt-get install -y libudev-dev > /dev/null 2>&1
}

instPackages;

if [ $? -ne 0 ]; then

	echo "Package installation had issues. Trying to fix..." | subStep
	apt-get -f install -y  > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Package installation failed." | subStep
		exit 1;
	fi

	apt-get autoremove -y  > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Package installation failed." | subStep
		exit 1;
	fi

	instPackages;

	if [ $? -ne 0 ]; then
		echo "Package installation failed." | subStep
		exit 1;
	else
		echo "Packages installed successfully." | subStep
	fi
fi


# Could also use:


echo "Upgrading needed packages." | step
apt-get upgrade -y  > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "Package upgrade failed." | subStep
	exit 1
fi

#echo "done.";
#exit;

#'
# end comment

echo "Prepping with cmake for compiling." | step

rm -rf $fullPath/goBuild

 /usr/bin/cmake -B$fullPath/goBuild -H$fullPath/goSrc -DUNICODE=0 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" > /dev/null 2>&1
# /usr/bin/cmake -B$fullPath/goBuild -H$fullPath/goSrc -DUNICODE=0 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles"

if [ $? -ne 0 ]; then
        echo "Cmake failed. Trying with ansi instead of unicode." | subStep
	rm -rf $fullPath/goBuild

        /usr/bin/cmake -B$fullPath/goBuild -H$fullPath/goSrc -DUNICODE=1 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" > /dev/null 2>&1
#        /usr/bin/cmake -B$fullPath/goBuild -H$fullPath/goSrc -DUNICODE=1 -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles"

        if [ $? -ne 0 ]; then
                echo "Cmake prep failed. GrandOrgue could not be installed." | subStep
                exit 1;
	fi
fi


echo "Prep for compile with cmake has been completed." | subStep

echo ; echo ; echo ;

echo "Warning: compiling could take several hours. Would you like to continue? [y/n]";
read option



if [ ! $option=="y" ] && [ !  $option=="Y" ]; then

	echo "Not continuing with compile.";
	echo "Feel free to run this script when you are ready.";
	echo ;
	echo "By the way, should you choose to run at a future "
	echo "    date, it will run much faster on this computer, ";
	echo "    as much of the initial work is complete.";
	echo ;
	echo "Exiting script.";
	exit 1;
fi

echo "Compilation can take several hours on the low power of a Raspberry Pi.";
echo "Would you like to see the logs of the compilation process ";
echo "    so that progress can be seen?"
echo ;
echo "If you select no, the screen will remain static for the ";
echo "    entire compilation process. ";
echo "If you select yes, a percentage counter will be incremented on screen.";
echo ;
echo "Select [Y/N]: ";
read optionOut;


if [ "$optionOut" != "y" ] && [  "$optionOut" != "Y" ]; then

	echo "You have selected not to show output.";
	echo "Please keep this terminal open to continue compilation.";
	echo ;
	/usr/bin/make -C $fullPath/goBuild > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "There was an error in compiling." | subStep
		exit 1;
	fi

else
	echo "Showing output.";
	echo "Please keep this terminal open to continue compilation.";
	echo ;
	/usr/bin/make -C $fullPath/goBuild
	if [ $? -ne 0 ]; then
		echo "There was an error in compiling." | subStep
		exit 1;
	fi

fi

echo "Compiling complete." | step

