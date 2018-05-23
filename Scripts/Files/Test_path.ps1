#Tests if path/folder exists
$servers = gc servers.txt

@(
foreach($s in $servers){
	write-output "On server $s"
    #Change desired path "c$\program files\opsware"
	if(test-path "\\$s\c$\program files\opsware"){
        write-output "C:\Program Files\Opsware'exists"
    }
	else{
        write-output "C:\Program Files\Opsware does not exist"
    }

    write-output "..."
}
) | out-file Test_path.txt