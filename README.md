# CSC2510FinalP
Final project in CSC 2510
# Shell Script Manual:

## Description
`autoGCP.sh`, is a shell script designed to take 3 inputs,#1 the IP address of the Virtual machine you are connecting to, #2 the ticket ID of the process you wan to execute, #3 your username. It will then connect to the Virtual Machine and copy serverSetup.sh to the VM and execute it.

## Important
- This script was made for the VM to be running Debian 12 (bookworm)

## Example
```bash
./AutoGCP.sh <GCP_Server_IP> <Ticket_ID> <Username>
```
### Parameters
- `<GCP_Server_IP>`: The external IP address of the Google Cloud Platform (GCP) server where the configurations will be applied.
- `<Ticket_ID>`: The ID of the ticket to be processed.
- `<Username>`: The username of the GCP account you are using.

This shell script, named `serverSetup.sh`, is designed to process tickets retrieved from a web service and execute configuration tasks specified in the tickets. It reads JSON data from a specified URL, processes the ticket corresponding to a given ticket ID, and logs the configuration actions and outcomes into a log file.

## Syntax
```bash
./serverSetup.sh <GCP_Server_IP> <Ticket_ID>
```
### Parameters
- `<GCP_Server_IP>`: The external IP address of the Google Cloud Platform (GCP) server where the configurations will be applied.
- `<Ticket_ID>`: The ID of the ticket to be processed.

## Author
Noah Herron

## Creation Date
April 30, 2024

## Prerequisites
- Ensure that` autoGCP.sh` has execute permissions (`chmod ### autoGCP.sh`).

## Functionality
1. **Retrieve Ticket Information**: The script retrieves ticket data from a specified URL (`https://www.swollenhippo.com/ServiceNow/systems/devTickets.php`) using `curl` and processes it using `jq`.
2. **Process Ticket**: It iterates through the retrieved ticket data to find the ticket matching the provided Ticket ID.
3. **Configuration Tasks**
   - **Software Package Installation**: It installs software packages specified in the ticket using `sudo apt-get install <Software_Package> -y`.
   - **Additional Configurations**: It executes additional configuration commands specified in the ticket. If the command contains `mkdir`, it creates a directory.
   - **Version Checking**: It checks the versions of installed software packages and logs them.
4. **Logging**: It logs all configuration actions and outcomes, including start and end times, requestor information, external IP, hostname, standard configuration, software package installations, additional configurations, version checks, and ticket closure status.
5. **Log Files**: Logs are stored in the `configurationLogs` directory with filenames corresponding to the Ticket ID. `e.g. 12345.log`


