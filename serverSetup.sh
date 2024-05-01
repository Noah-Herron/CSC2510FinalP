#! /bin/bash

# Description: This script takes 2 inputs IP and ticketID
# based on the given ticketID the script will parse the JSON using jq, and 
# install the specified software and execute additional configs.
# This script also creates a log file that keeps track of all the installs 
# and configs, and outputs it all to the ticket ID lg file in the configurationLogs directory
# Example: 12345.log
# Example Inputs: 34.234.543.23 12345
#
# Author: Noah Herron

# Creation: 4/27/2024

# External IP address of the GCP server
gcpIP=$1

# The ticket ID to be processed
ticketID=$2

# checking for updates and installing jq
sudo apt-get update
sudo apt-get install jq -y

# Getting URL of the web service
strURL="https://www.swollenhippo.com/ServiceNow/systems/devTickets.php"

# Getting the json form the URL
arrResults=$(curl ${strURL} | jq)
# debug statement to test if arrResults is correct
#echo ${arrResults}

# getting the length and setting it to intLength
intLength=$(echo ${arrResults} | jq "length")
# debug to test length
#echo ${intLength}

# index to move throught the array in json
intIndex=0
# secondary index
intSecIndex=0
# third index for while loop version
intThirIndex=0
# index for Config Loop
intConfigIndex=0

# setting the date
strStartDate=$(date +"%d-%b-%Y %R")
#debug to make sure date is correct
#echo ${strStartDate}

while [ $intIndex -lt $intLength ]; do
	intTickID=$(echo ${arrResults} | jq .[${intIndex}].ticketID)
	# debug to ensure intTickID is correct
	#echo ${intTickID}

	if [ $intTickID = $ticketID ]; then

		# getting the requestors name
		strReqName=$(echo ${arrResults} | jq .[${intIndex}].requestor)
		# removing the parenthases around the requestors name
		strReqName=${strReqName:1:-1}
		# debug statment to make sure requestor name is correct
		#echo ${strReqName}

		# getting the requestors name
		strConfig=$(echo ${arrResults} | jq .[${intIndex}].standardConfig)
		# removing the parenthases around the strConfig
		strConfig=${strConfig:1:-1}
		# debug statment to make sure Config name is correct
		#echo ${strConfig}

		strSoftwarePackages=$(echo "$arrResults" | jq -r .[${intIndex}].softwarePackages)
		numPackages=$(echo "$strSoftwarePackages" | jq length)
		# debug to test number of packages is correct
		#echo ${numPackages}

		strHostName=$(hostname)

		# Making the log directory
		mkdir configurationLogs

		# Making the log file
		#touch $ticketID configurationLogs/${ticketID}.log

		# Adding the logs to the log file
		echo "TicketID: ${ticketID}" >> configurationLogs/${ticketID}.log
		echo "Start DateTime: ${strStartDate}" >> configurationLogs/${ticketID}.log
		echo "Requestor: ${strReqName}" >> configurationLogs/${ticketID}.log
		echo "External IP: ${gcpIP}" >> configurationLogs/${ticketID}.log
		echo "Hostname: ${strHostName}" >> configurationLogs/${ticketID}.log
		echo "Standardconfiguration: ${strConfig}" >> configurationLogs/${ticketID}.log
		echo "" >> configurationLogs/${ticketID}.log

		# debug to test if host name is correct
		#echo ${strHostName}
		while [ $intSecIndex -lt $numPackages ]; do
			strPackage=$(echo ${strSoftwarePackages} | jq .[${intSecIndex}].install)
			#echo ${strPackage}
			# removing the parenthases from th string
			strPackage=${strPackage:1:-1}
			# debug testing if correctly removed the parenthases
			#echo $strPackage

			# checking for updates
			sudo apt-get update

			# epoch time when download starts
			strEpochDownload=$(date +"%s")
			# debug to test strEpochDownload
			#echo ${strEpochDownload}

			# installing the specified package
			sudo apt-get install $strPackage -y

			# Adding the message below to the corresponding log file
			echo "SoftwarePackage - ${strPackage} - ${strEpochDownload}" >> configurationLogs/${ticketID}.log

			((intSecIndex++))
		done

		# reading the configs from the JSON
		strConfigs=$(echo "$arrResults" | jq -r .[${intIndex}].additionalConfigs)
		numConfigs=$(echo "$strConfigs" | jq length)

		while [ $intConfigIndex -lt $numConfigs ]; do
			# getting epoch time at the start of the download
			strEpoch=$(date +"%s")
			strConfigName=$(echo ${strConfigs} | jq .[${intConfigIndex}].name)
			# removing the parenthases from th string
			strConfigName=${strConfigName:1:-1}
			# debug testing if correctly removed the parenthases
			#echo $strConfigName

			strConfig=$(echo ${strConfigs} | jq .[${intConfigIndex}].config)
			# removing the parenthases from th string
			strConfig=${strConfig:1:-1}
			# debug testing if correctly removed the parenthases
			#echo $strConfig

			# getting the path to the specified file, and creating directories to get there if needed
			if [[ $strConfig == *"touch"* ]]; then
				strPath=$(echo ${strConfig})
				strPath=$(echo $(echo ${strPath}) | sed -e 's/touch //')
				strPath=$(echo $(echo ${strPath}) | sed -e 's![^/]*$!!')
				eval $(sudo mkdir -p ${strPath})
			fi

			# executing the specified config command
			eval $(sudo ${strConfig})

			# Adding the version of each software Package to the log file
			echo "additionalConfig - ${strConfigName} - ${strEpoch}" >> configurationLogs/${ticketID}.log

			((intConfigIndex++))
		done

		echo "" >> configurationLogs/${ticketID}.log

		while [ $intThirIndex -lt $numPackages ]; do
			strPackage=$(echo ${strSoftwarePackages} | jq .[${intThirIndex}].install)
			#echo ${strPackage}
			# removing the parenthases from th string
			strPackage=${strPackage:1:-1}
			# debug testing if correctly removed the parenthases
			#echo $strPackage
			strVer=$(dpkg -s $strPackage | grep -i version)
			# Adding the version of each software Package to the log file
			echo "Version Check - ${strPackage} - ${strVer}" >> configurationLogs/${ticketID}.log

			((intThirIndex++))
		done
		# End of the Log file
		echo "" >> configurationLogs/${ticketID}.log
		echo "TicketClosed" >> configurationLogs/${ticketID}.log
		echo "" >> configurationLogs/${ticketID}.log

		strEndDate=$(date +"%d-%b-%Y %R")
		# debug to test end date
		#echo ${strEndDate}

		echo "Completed: ${strEndDate}" >> configurationLogs/${ticketID}.log

	fi

	((intIndex++))
done


