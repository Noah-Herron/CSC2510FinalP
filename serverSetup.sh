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
        intTickID=$(echo ${arrResults} | jq .[${intIndex}].ticketID)

	if [ $intTickID = $ticketID ]; then

	        # getting the requestors name
        	strReqName=$(echo ${arrResults} | jq .[${intIndex}].requestor)
			# removing the parenthases around the requestors name
			strReqName=${strReqName:1:-1}
	        # debug statment to make sure requestor name is correct
        	echo ${strReqName}

        	# getting the requestors name
	        strconfig=$(echo ${arrResults} | jq .[${intIndex}].standardConfig)
			# removing the parenthases around the strConfig
			strConfig=${strConfig:1:-1}
        	# debug statment to make sure Config name is correct
        	#echo ${strConfig}

        	strSoftwarePackages=$(echo "$arrResults" | jq -r .[${intIndex}].softwarePackages)
        	numPackages=$(echo "$strSoftwarePackages" | jq length)
        	# debug to test number of packages is correct
        	echo ${numPackages}

	        strHostName=$(whoami)

        	# debug to test if host name is correct
         	#echo ${strHostName}
        	while [ $intSecIndex -lt $numPackages ]; do
                	strPackage=$(echo ${strSoftwarePackages} | jq .[${intSecIndex}].install)
                	#echo ${strPackage}
                	# removing the parenthases from th string
                	strPackage=${strPackage:1:-1}
                	# debug testing if correctly removed the parenthases
                	#echo $strPackage
                	sudo apt-get update
                	sudo apt-get install $strPackage -y

                	((intSecIndex++))
        	done

		# Making the log directory
		mkdir ~/configurationLogs

		# Making the log file
		touch $intTicketID

		# Adding the logs to the log file
		echo "TicketID: ${intTickID}"
		echo "Start DateTime: ${strStartDate}"
		echo "Requestor: ${strReqName}"
		echo "External IP: ${gcpIP}"
		echo "Hostname: ${strHostName}"
		echo "Standard Configuration: ${strConfig}"
		echo ""
		echo "SoftwarePackage - ${strPackage} - TIME STAMP"
		echo ""
		echo "Version Check - ${strPackage} - VERSION"
		echo ""
		echo "TicketClosed"

		strEndDate=$(date +"%d-%b-%Y %R")
		# debug to test end date
		echo ${strEndDate}

		echo "Completed: ${strEndDate}"

	fi

        ((intIndex++))
done


