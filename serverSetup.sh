#! /bin/bash

# Description:
#
#

# Author: Noah Herron

# Creation: 4/27/2024

# External IP address of the GCP server
gcpIP=$1

# The ticket ID to be processed
ticketID=$2

# Getting URL of the web service
strURL="https://www.swollenhippo.com/ServiceNow/systems/devTickets.php"

# Getting the json form the URL
arrResults=$(curl ${strURL} | jq)
# debug statement to test if arrResults is correct
echo ${arrResults}

# getting the length and setting it to intLength
intLength=$(echo ${arrResults} | jq "length")
# debug to test length
#echo ${intLength}

# index to move throught the array in json
intIndex=0
# secondary index
intSecIndex=0

# setting the date
strStartDate=$(date +"%d-%b-%Y %R")
#debug to make sure date is correct
echo ${strStartDate}

while [ $intIndex -lt $intLength ]; do
	intTickID=$(echo ${arrResults} |jq .[${intIndex}].ticketID)
	# debug to test strPackLength
	echo ${strPackLength}

	# getting the requestors name
	strReqName=$(echo ${arrResults} | jq .[${intIndex}].requestor)

	# debug statment to make sure requestor name is correct
	echo ${strReqName}

	# getting the requestors name
	strconfig=$(echo ${arrResults} | jq .[${intIndex}].standardConfig)

	# debug statment to make sure Config name is correct
	echo ${strConfig}

	strSoftwarePackages=$(echo "$arrResults" | jq -r .[$intIndex].softwarePackages)
	numPackages=$(echo "$strSoftwarePackages" | jq length)
	# debug to test number of packages is correct
	echo ${numPackages}


	((intIndex++))
done
