#Script to change DHCP scope and add new reservation


#Variables
$SCOPE = read-host 'insert SCOPE'
$IP = read-host 'insert IP'
$MAC = read-host 'insert MAC'
$HOSTNAME = read-host 'insert HOSTNAME'
$DESCRIPTION = read-host 'insert DESCRIPTION'
$StartRemovalIP = read-host 'insert first scope IP range for removal'
$EndRemovalIP = read-host 'insert last scope IP range for removal'
$StartAddIP = read-host 'insert first scope IP range for add'
$EndAddIP = read-host 'insert last scope IP range for add'


#Add New DHCP Reservation
netsh DHCP server scope $SCOPE add reservedip $IP $MAC $HOSTNAME $DESCRIPTION "BOTH"
echo "DHCP reservation added"

#Delete Adress Pool
netsh DHCP server scope $SCOPE delete excluderange $StartRemovalIP $EndRemovalIP
echo "DHCP exclusion range removed"

#Add Adress Pool
netsh DHCP server scope $SCOPE add excluderange $StartAddIP $EndAddIP
echo "DHCP exclusion range added"

#Replication 
#Invoke-DhcpServerv4FailoverReplication -ComputerName "xxx" -ScopeId $SCOPE -force

#Write proof
write-output "From DHCP Scope:" | out-file -append -filepath DHCPProof.txt 
Get-DhcpServerv4scope -scope $SCOPE | Format-Table -Property ScopeID, Name -autosize | out-file -append -filepath DHCPProof.txt

write-output "Reservation added:" | out-file -append -filepath DHCPProof.txt 
Get-DhcpServerv4Reservation -IPAddress $IP | Format-Table -Property Name, IPAddress, @{n='MAC';e={$_.ClientID}}, Description, Type -autosize | out-file -append  -filepath DHCPProof.txt 

write-output "Actual Exclusion Ranges:" | out-file -append -filepath DHCPProof.txt 
Get-DhcpServerv4ExclusionRange -scope $SCOPE | Format-Table -Property StartRange, EndRange -autosize | out-file -append -filepath DHCPProof.txt

