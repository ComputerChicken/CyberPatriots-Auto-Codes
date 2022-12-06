$Password = ConvertTo-SecureString "xxxx" -AsPlainText -Force

$authUsers = @()
$regUsers = Invoke-Command -ScriptBlock { net user}

Write-Host "Admin Users (copy + paste from readme):"
while ( $true ) {
    $user = Read-Host
    if ( $user -eq "stop" ) {
        break
    }
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
    New-LocalUser $user -Password $Password -FullName $user -Description $user -ErrorAction Ignore
    Remove-LocalGroupMember -Group "Administrators" -Member $user -ErrorAction Ignore
    Add-LocalGroupMember -Group "Users" -Member $user -ErrorAction Ignore 
    $authUsers += $user
}
Write-Host "Scanning for Unauthentic Users..."
foreach($d in $regUsers.Split())
{
	if($d -notin $authUsers) {
		Remove-LocalUser $d -Password $Password -ErrorAction Ignore
	}
}
