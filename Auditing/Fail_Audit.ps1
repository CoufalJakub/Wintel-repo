#Sets Auditing On file/folder as full control on fail

$computer = gc servers.txt

#Modify path+user/group to audit

$path = "C:\Windows\system32"
$user = "everyone"


$path = $path.replace("\", "\\")
$SD = ([WMIClass] "Win32_SecurityDescriptor").CreateInstance()
$ace = ([WMIClass] "Win32_ace").CreateInstance()
$Trustee = ([WMIClass] "Win32_Trustee").CreateInstance()
$SID = (new-object security.principal.ntaccount $user).translate([security.principal.securityidentifier])
[byte[]] $SIDArray = ,0 * $SID.BinaryLength
$SID.GetBinaryForm($SIDArray,0)
$Trustee.Name = $user
$Trustee.SID = $SIDArray

#Modify if you need different values than FullControl
$ace.AccessMask = [System.Security.AccessControl.FileSystemRights]"FullControl"
$ace.AceFlags = 131
$ace.AceType = 2
$ace.Trustee = $trustee
$SD.SACL = $ace
$SD.ControlFlags="0x10"
$wPrivilege = gwmi Win32_LogicalFileSecuritySetting -computername $computer -filter "path='$path'"
$wPrivilege.psbase.Scope.Options.EnablePrivileges = $true
$wPrivilege.setsecuritydescriptor($SD)