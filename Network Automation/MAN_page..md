networkconfig.sh

NAME
networkconfig.sh - for RHEL network configuration

DESCRIPTION
This script will show the current configured network parameters in the available files in tabular format. User will then be asked the parameter name and then its corresponding value, then the corresponding parameter value will be updated in the file.

OPTIONS
-d Configure domain name
-h Configure hosts file
-i filename
import configurations from csv format file with comma-separated values. Format of file should be parameter-name,parameter-value
-I interface-name
Shows only interface related parameters and then they can be configured
-n Configure nameserver/DNS
-p param=parameter-name value=parameter-value
Updates the parameter in related files.
-s Only display current configuration
-S Configure sysctl parameters
