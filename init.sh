#!/bin/sh 
DEMO="OpenShift Origin Demo"
AUTHORS="Eric D. Schabell"
PROJECT="git@github.com:eschabell/openshift-origin-demo.git"
PRODUCT="OpenShift Origin Image"
ORIGIN_HOME=./target
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
VAGRANT_FILE=Vagrantfile
OC_LINUX=openshift-origin-client-tools-v1.1.1-e1d9873-linux-64bit.tar.gz
OC_MAC=openshift-origin-client-tools-v1.1.1-e1d9873-mac.zip
VERSION=1.1.1

# wipe screen.
clear 

echo
echo "###############################################################"
echo "##                                                           ##"   
echo "##  Setting up the ${DEMO}                     ##"
echo "##                                                           ##"   
echo "##                                                           ##"   
echo "##    ###  ####  ##### #   #  #### #   # ##### ##### #####   ##"
echo "##   #   # #   # #     ##  # #     #   #   #   #       #     ##"
echo "##   #   # ####  ###   # # #  ###  #####   #   ###     #     ##"
echo "##   #   # #     #     #  ##     # #   #   #   #       #     ##"
echo "##    ###  #     ####  #   # ####  #   # ##### #       #     ##"
echo "##                                                           ##"   
echo "##                                                           ##"   
echo "##  brought to you by, ${AUTHORS}                      ##"
echo "##                                                           ##"   
echo "##  ${PROJECT}       ##"
echo "##                                                           ##"   
echo "###############################################################"
echo

command -v vagrant -v >/dev/null 2>&1 || { echo >&2 "Vagrant is required but not installed yet... download here: https://www.vagrantup.com/downloads.html"; exit 1; }
echo "Vagrant is installed..."
echo 

command -v VirtualBox -h >/dev/null 2>&1 || { echo >&2 "VirtualBox is required but not installed yet... downlaod here: https://www.virtualbox.org/wiki/Downloads"; exit 1; }
echo "VirtualBox is installed..."
echo

# Remove the old insallation, if it exists.
if [ -x $ORIGIN_HOME ]; then
	echo "  - removing existing installation..."
	echo
	rm -rf $ORIGIN_HOME
fi

# Run installation.
echo "Setting up installation now..."
echo
mkdir $ORIGIN_HOME

echo "Setup vagrant file..."
echo
cp $SUPPORT_DIR/$VAGRANT_FILE $ORIGIN_HOME

echo "Setting up OpenShift commandline tools..."
mkdir $ORIGIN_HOME/bin

if [[ `uname` == 'Darwin' ]]; then
	unzip -q $SUPPORT_DIR/$OC_MAC -d $ORIGIN_HOME/bin
else 
  tar -zvf $SUPPORT_DIR/$OC_LINUX -d $ORIGN_HOME/bin
fi

echo
echo "Downloading and installing OpenShift via Vagrant...."
echo
echo "  ...be patient, it's a big file!"
echo
cd $ORIGIN_HOME
vagrant up --provider=virtualbox

if [ $? -ne 0 ]; then
	echo
	echo "Error occurred during installation of Vagrant enviornment..."
	echo
	echo "Most likely encountered a previously installed environment, you"
	echo "first need to remove this by locating its ID here:"
	echo
	vagrant "global-status"
	echo
  echo "Now remove it with:"
	echo
	echo "  $ vagrant destroy [id]"
	echo
	echo "When this is done, re-try the openshift-install-demo installation."
	echo
	exit
fi

echo
echo "To use installed CLI tooling add the following to your path for access:" 
echo
echo "  $ export PATH=\$PATH:`pwd`/bin"
echo
echo "==================================================================="
echo "=                                                                 ="
echo "= After adding to path, you can use 'oc' from CLI to login:       ="
echo "=                                                                 ="
echo "=  $ oc login https://10.2.2.2                                    ="
echo "=                                                                 ="
echo "=  Authentication required for https://10.2.2.2:8443 (openshift)  ="
echo "=  Username: {insert-any-login-here}                              ="
echo "=                                                                 ="
echo "=  Login successful.                                              ="
echo "=                                                                 ="
echo "=  You don't have any projects. You can try to create a new       ="
echo "=  project, by running:                                           ="
echo "=                                                                 ="
echo "=  $ oc new-project                                               ="
echo "=                                                                 ="
echo "==================================================================="
echo
echo "==================================================================="
echo "=                                                                 ="
echo "= Now login via browser to OpenShift: https://10.2.2.2:8443       ="
echo "=                                                                 ="
echo "= $DEMO Setup Complete.                      ="
echo "=                                                                 ="
echo "==================================================================="
echo

