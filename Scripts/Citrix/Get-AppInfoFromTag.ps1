Function Convert-OutputForCSV {
    <#
        .DESCRIPTION
            Provides a way to expand collections in an object property prior
            to being sent to Export-Csv. This helps to avoid the object type
            from being shown such as system.object[] in a spreadsheet.
        .NOTES
            Name: Convert-OutputForCSV
            Author: Boe Prox
            Created: 24 Jan 2014    
    #>
    #Requires -Version 3.0
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [parameter()]
        [ValidateSet('Stack','Comma')]
        [string]$OutputPropertyType = 'Stack'
    )
    Begin {
        $PSBoundParameters.GetEnumerator() | ForEach {
            Write-Verbose "$($_)"
        }
        $FirstRun = $True
    }
    Process {
        If ($FirstRun) {
            $OutputOrder = $InputObject.psobject.properties.name
            Write-Verbose "Output Order:`n $($OutputOrder -join ', ' )"
            $FirstRun = $False
            #Get properties to process
            $Properties = Get-Member -InputObject $InputObject -MemberType *Property
            #Get properties that hold a collection
            $Properties_Collection = @(($Properties | Where-Object {
                $_.Definition -match "Collection|\[\]"
            }).Name)
            #Get properties that do not hold a collection
            $Properties_NoCollection = @(($Properties | Where-Object {
                $_.Definition -notmatch "Collection|\[\]"
            }).Name)
            Write-Verbose "Properties Found that have collections:`n $(($Properties_Collection) -join ', ')"
            Write-Verbose "Properties Found that have no collections:`n $(($Properties_NoCollection) -join ', ')"
        }
        $InputObject | ForEach {
            $Line = $_
            $stringBuilder = New-Object Text.StringBuilder
            $Null = $stringBuilder.AppendLine("[pscustomobject] @{")

            $OutputOrder | ForEach {
                If ($OutputPropertyType -eq 'Stack') {
                    $Null = $stringBuilder.AppendLine("`"$($_)`" = `"$(($line.$($_) | Out-String).Trim())`"")
                } ElseIf ($OutputPropertyType -eq "Comma") {
                    $Null = $stringBuilder.AppendLine("`"$($_)`" = `"$($line.$($_) -join ', ')`"")                   
                }
            }
            $Null = $stringBuilder.AppendLine("}")
            Invoke-Expression $stringBuilder.ToString()
        }
    }
    End {}
}

<#
    .DESCRIPTION
            Script to find Application name, Users/Groups allowed to connect, Executable location from server tags
    .NOTES
            Name: Get-AppInfoFromTag
            Author: Jakub Coufal  
#>

add-pssnapin *citrix*

$servers = Get-Content servers.txt
$AllApps =@()

foreach($server in $servers){
    $server1 = "*"+$server
    #Checks server for tags with "BT PUB"
    $tags = (get-brokermachine -machinename $server1).tags | Select-String -pattern "BT PUB"
    #Removes "BT PUB xxx" to find application name
    $tags = $tags -replace("BT PUB \w\w\w ","")


    #Cycles through all tags on server
    foreach ($tag in $tags){
        $Name = (Get-BrokerApplication -ApplicationName $tag).PublishedName
        $Exec = (Get-BrokerApplication -ApplicationName $tag).CommandLineExecutable
        $Users = (Get-BrokerApplication -ApplicationName $tag).AssociatedUserNames
        #Removes "contoso\" domain from users/groups
        $Users = $Users -replace("contoso\\","")
        
        #creates custom object for easier output
        $object = new-object psobject -property @{
            Server = $server
            Publishedname = $Name
            Executable = $Exec
            AssociatedUsernames = $Users
        }
        $AllApps+=$object   
    }
}
write-output $AllApps | select-object Server, PublishedName, AssociatedUserNames, Executable | Convert-OutputForCSV | Export-Csv -NoTypeInformation -path Get-AppInfoFromTag.csv 
