$Password = ConvertTo-SecureString "xxxx" -AsPlainText -Force
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
}
