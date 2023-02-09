#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	ZeroRenameName.sh
#	https://github.com/Headbolt/ZeroRenameName
#
#   This Script is designed for use in JAMF
#
#	The Following Variables should be defined
#	Variable 4 - Named "Prefix - eg. COMP-"
#
#   - This script will ...
#		Grab the Machines name locally.
#		Grab the Machines Serial Number locally.
#		Grab a Prefix, from JAMF variable #4
#		Rename if needed
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.0 - 09/02/2023
#
#	09/02/2023 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
# Variables used by this script.
#
Prefix=$4 # Grab the Prefix from JAMF variable #4 eg. COMP-
ScriptName="MacOS | Rename Machine" # Set the name of the script for later logging
ExitCode=0
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Check Details Function
#
CheckDetails(){
#
CurrentName=$(scutil --get ComputerName) # This gets the Mac's current name
Serial=$(system_profiler SPHardwareDataType | grep "Serial Number" | awk '{print $4}') # This gets the Mac's Serial Number
NewName="$Prefix$Serial"
#
/bin/echo 'Current Computer name is "'$CurrentName'"' # Rename the Mac to the assigned name
/bin/echo 'Computer Serial Number is "'$Serial'"' # Rename the Mac to the assigned name
/bin/echo 'Requested Prefix is "'$Prefix'"' # Rename the Mac to the assigned name
/bin/echo 'Desired name is "'$NewName'"' # Rename the Mac to the assigned name
#
}   
#
###############################################################################################################################################
#
# Rename Function
#
Rename(){
#
/bin/echo 'Computer name is NOT correct'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo 'Renaming Computer from "'$CurrentName'" to "'$NewName'"' # Rename the Mac to the assigned name
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo 'Running command "/usr/local/bin/jamf setComputerName -name '$NewName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/usr/local/bin/jamf setComputerName -name $NewName
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
exit $ExitCode
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
#
/bin/echo 'Checking Current Details'# Outputting a Blank Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
CheckDetails
SectionEnd
#
if [[ "$CurrentName" == "$NewName" ]] 
	then
		/bin/echo 'Computer name is correct'
		/bin/echo 'Nothing To Do'
	else
		Rename
        SectionEnd
		/bin/echo 'Re-Checking Current Details' # Outputting a Blank Line for Reporting Purposes
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		CheckDetails
        SectionEnd
		/bin/echo 'Running an Inventory, to update details in JAMF'
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		/usr/local/bin/jamf recon
fi
#
SectionEnd
ExitCode=0
ScriptEnd
