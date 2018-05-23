Get-Content servers.txt | Foreach-Object {
    rename-item -path "\\$_\c$\Program Files\NSClient++\NSC.ini" backup_NSC.ini
}