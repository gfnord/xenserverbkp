xe vm-list | \
awk '{if ( $0 ~ /uuid/) {uuid=$5} if ($0 ~ /name-label/) \
{$1=$2=$3="";vmname=$0; printf "%s - %s\n", vmname, uuid}}'

