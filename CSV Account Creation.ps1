#Import required modules
Import-Module ActiveDirectory

#Create default password
$Password = Read-Host -Prompt "Default Password: " -AsSecureString

#CSV filepath prompt
$Filepath = Read-Host -Prompt "Please provide CSV filepath: "

#Import CSV to variable
$Users = Import-Csv $Filepath

#Loop through CSV
foreach ($user in $Users)
{
    $Fname = $user.'First Name'
    $Lname = $user.'Last Name'
    $Uname = $user.'User Name'
    $Eaddress = $user.'Email Address'
    $OUpath = $user.'Organizational Unit'

    #Create new AD account for each user in CSV
    $Params = 
    @{
        Name                  = "$Fname $Lname"
        GivenName             = $Fname
        Surname               = $Lname
        SamAccountName        = $Uname
        UserPrincipalName     = "$Uname@$Domain"
        Path                  = $OUpath
        AccountPassword       = $Password
        EmailAddress          = $Eaddress
        ChangePasswordAtLogon = $true
        Enabled               = $true 
    }

    New-ADUser @Params
    
    #Echo output for each account
    Write-Output "Account created for $Fname $Lname in $OUpath"
}
