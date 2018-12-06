$servers = get-content servers.txt

@(
foreach($server in $servers){
    write-output "---------------"
    write-output $server
	$server1 = "*"+$server
    (get-brokermachine -machinename $server1).tags
    write-output ""
}) | out-file tags.txt
