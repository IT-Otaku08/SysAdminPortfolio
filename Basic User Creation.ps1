# Import required modules
Import-Module ActiveDirectory

# Create default password
$Password = Read-Host -Prompt "Default Password:" -AsSecureString

# Specify user account storage location
$OUpath = "OU=Users,OU=Home,DC=home,DC=local"

$ExitRequested = ""

while ($ExitRequested -ne "Q")
{
    # Store user's name & password into variables
    $FirstName = Read-Host -Prompt "Employee's First Name: "
    $LastName = Read-Host -Prompt "Employee's Last Name: "
    $UserName = $FirstName[0] + $LastName

    # Create new AD account for each user
    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName "$UserName" `
        -UserPrincipalName "$UserName@home.local" `
        -Path $OUpath `
        -AccountPassword $Password `
        -ChangePasswordAtLogon $true `
        -Enabled $true

    # Loop exit?
    $ExitRequested = Read-Host -Prompt "Press 'Q' to end account creation: "
}