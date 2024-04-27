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
echo ${intLength}
intIndex=0

# setting the date
strStartDate=$(date +"%d-%b-%Y %R")
#debug to make sure date is correct
echo ${strStartDate}

while [ $intIndex -lt $intLength ]; do
	# getting the requestors name
	strReqName=$(echo ${arrResults} | jq .[intIndex].requestor)
	# debug statment to make sure requestor name is correct
	echo ${strReqName}
done
