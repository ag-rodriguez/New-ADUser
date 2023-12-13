Import-Module ActiveDirectory

# Store the data from the CSV file in the $Users variable
$Users = Import-csv "C:\Users\Alex\Documents\users.csv" # Modify to match the location of your .csv file

# Loop through each row containing user details in the CSV file 
foreach ($User in $Users) {
    # Construct the user logon name
    $userLogonName = $("{0}{1}" -f $User.FirstName.Substring(0,1), $User.LastName).ToLower() # Change this if you want a different naming convention

    # Create a hashtable for splatting the parameters
    $userProps = @{
        SamAccountName         = $userLogonName
        UserPrincipalName      = "$userLogonName@SECURITYLABS.local" # Modify to match your own
        Name                   = "$($User.FirstName) $($User.LastName)"
        GivenName              = $User.FirstName
        Surname                = $User.LastName
        AccountPassword        = (ConvertTo-SecureString -AsPlainText -Force -String $User.Password)
        Path                   = "OU=Userss,DC=SECURITYLABS,DC=local" # Make sure modify to match your own path
        Enabled                = $true 
        ChangePasswordAtLogon  = $false
    }

    try {
        New-ADUser @userProps -Verbose
    } catch {
        Write-Host "Error creating user $($userLogonName): $($_.Exception.Message)"
    }
}
