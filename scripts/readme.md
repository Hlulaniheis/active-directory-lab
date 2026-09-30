# Scripts

Custom PowerShell scripts written for this lab. Each script is standalone and can be run in an elevated PowerShell session on a domain controller (or a domain-joined machine with the AD PowerShell module installed).

---

## BulkCreateUsers.ps1

Bulk provisions Active Directory user accounts from a CSV file.

**What it does:**
- Imports a CSV with columns: `FirstName`, `LastName`, `Username`, `Department`, `Title`
- Builds a `New-ADUser` parameter set for each row
- Sets a default password that the user must change at first logon
- Uses a `try` / `catch` block so a single failure doesn't stop the whole batch
- Reports green "Created" lines for each success, red for each failure

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File .\BulkCreateUsers.ps1
