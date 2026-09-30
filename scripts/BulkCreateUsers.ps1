# Path to the CSV
$CSVPath = "C:\Users\azureuser\Desktop\NewUsers.csv"

# Default password (user must change at first logon)
$DefaultPassword = ConvertTo-SecureString "P@ssw0rd2026!" -AsPlainText -Force

# Import the CSV and loop through each row
Import-Csv $CSVPath | ForEach-Object {

    # Build the properties
    $Params = @{
        GivenName             = $_.FirstName
        Surname               = $_.LastName
        Name                  = "$($_.FirstName) $($_.LastName)"
        SamAccountName        = $_.Username
        UserPrincipalName     = "$($_.Username)@LanisLab.co.za"
        DisplayName           = "$($_.FirstName) $($_.LastName)"
        Department            = $_.Department
        Title                 = $_.Title
        Path                  = "CN=Users,DC=LanisLab,DC=co,DC=za"
        AccountPassword       = $DefaultPassword
        Enabled               = $true
        ChangePasswordAtLogon = $true
    }

    # Create the user
    try {
        New-ADUser @Params
        Write-Host "Created: $($_.Username)" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: $($_.Username) - $($_.Exception.Message)" -ForegroundColor Red
    }
}
