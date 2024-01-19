$Password = ConvertTo-SecureString "securepassword" -AsPlainText -Force

$authUsers = @()
$regUsers = Invoke-Command -ScriptBlock { net user}

Write-Host "Admin Users (copy + paste from readme):"
while ( $true ) {
    $user = Read-Host
    if ( $user -eq "stop" ) {
        break
    }
    Set-LocalUser -Name $user -Password $Password -Verbose
    New-LocalUser $user -Password $Password -FullName $user -Description $user -ErrorAction Ignore
    Remove-LocalGroupMember -Group "Users" -Member $user -ErrorAction Ignore
    Add-LocalGroupMember -Group "Administrators" -Member $user -ErrorAction Ignore 
}
Write-Host "Standard Users (copy + paste from readme):"
while ( $true ) {
    $user = Read-Host
    if ( $user -eq "stop" ) {
        break
    }
    Set-LocalUser -Name $user -Password $Password -Verbose
    New-LocalUser $user -Password $Password -FullName $user -Description $user -ErrorAction Ignore
    Remove-LocalGroupMember -Group "Administrators" -Member $user -ErrorAction Ignore
    Add-LocalGroupMember -Group "Users" -Member $user -ErrorAction Ignore 
    $authUsers += $user
}
Write-Host "Scanning for Unauthentic Users..."
foreach($d in $regUsers.Split())
{
Write-Host $d
	if($d -notin $authUsers) {
		#Remove-LocalUser -Name $d
	}
}
Write-Host "Enabling Firewall..."
Set-NetFirewallProfile -Enabled True
Write-Host "Getting Executables..."
$exes = (cmd.exe /c "dir .\*.exe /s") -join "`n"
$MyInvocation.MyCommand.Path
$dir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$filedir = $dir,"executables.txt" -join "\"
$exes | Out-File -FilePath $filedir
Write-Host "Updating Software..."
Update-Module
Write-Host "Remember to do windows updates and password policies!"
