Active Directory Lab - Windows Server 2025

A hands-on Active Directory lab built on Windows Server 2025, demonstrating the day-to-day tasks a Tier 1 / Tier 2 IT Technician or Junior Sysadmin performs: user lifecycle management, group nesting, GPO configuration, offboarding, AD Recycle Bin recovery, stale object auditing, OU delegation, and PowerShell automation.

Domain: lanislab.co.za
NetBIOS: LANISLAB
Forest Functional Level: Windows Server 2025


Tech Stack

Windows Server 2025 (Domain Controller, DNS, Hyper-V host)
Active Directory Domain Services (AD DS)
Group Policy Management (GPMC / GPME)
PowerShell 5.1 (AD module, Search-ADAccount, New-ADUser, Unlock-ADAccount, custom scripts)
CMD tools (netdom, gpupdate)


Tasks Completed

User Lifecycle

Create user from scratch - ADUC GUI - screenshots 02, 03
Create user by copying a template - ADUC Copy wizard - screenshots 11 to 19
Bulk create users from CSV - PowerShell New-ADUser - screenshots 20 to 23
Unlock a locked user account - Unlock-ADAccount - screenshot 10
Modify UPN suffix after a company merger - AD Domains and Trusts plus ADUC - screenshots 24, 25

Groups and Permissions

Create Security vs Distribution groups - ADUC - screenshots 14, 26
Nested group membership (Sales Team inside All Staff) - ADUC Members tab - screenshot 31
Find all groups a user belongs to including nested - custom PowerShell recursion - screenshots 28 to 30
Export all group members to CSV - Get-ADGroupMember -Recursive plus Export-Csv - screenshots 33, 34

Group Policy

Configure account lockout policy (5 attempts, 15 min) - GPME Default Domain Policy - screenshots 05 to 08
Force policy update - gpupdate /force - screenshot 09

Offboarding and Recovery

Disable, reset password, strip groups, move to Disabled Users OU - PowerShell - screenshot 38
Enable AD Recycle Bin - Enable-ADOptionalFeature - screenshot 41
Delete a user and restore from Recycle Bin - Remove-ADUser plus Restore-ADObject - screenshot 44

Computer Objects and Auditing

Create and move a computer object between OUs - Move-ADObject - screenshot 50
Find and disable stale computers (last logon over 90 days) - LastLogonTimeStamp plus Set-ADComputer - screenshots 52, 53
Audit inactive accounts - Search-ADAccount -AccountInactive - screenshots 54, 55

Delegation and FSMO

Delegate OU control to a junior tech group - Delegation of Control Wizard - screenshots 56 to 59
Identify FSMO role holders - netdom query fsmo - screenshot 62


Scripts

Custom PowerShell scripts are in the scripts folder:

BulkCreateUsers.ps1 - imports a CSV and provisions users with department, title, and UPN attributes
Get-NestedGroups.ps1 - recursively walks group membership upward using a queue, returning all direct and nested groups for a user


What I Learned

LastLogonTimeStamp is a raw Int64. It must be converted with [DateTime]::FromFileTime() before comparison. Search-ADAccount does this automatically.

Disable-ADAccount does not always resolve computer objects by SamAccountName. Set-ADComputer -Enabled $false is more reliable.

AD Recycle Bin must be enabled before deletion for a clean restore. Otherwise you fall back to the messier LDP tombstone-reanimation method.

Group nesting directions matter. The Members tab shows what is inside a group. The Member Of tab shows what a group belongs to. Mixing them up leads to silent misconfigurations.

Delegation modifies an OU's ACL, not group membership. A junior tech can get password-reset rights on one OU without any Domain Admin rights.


Lab Environment

Host: Azure VM running Windows Server 2025 with Hyper-V
Domain Controller: vm-hyperv-host.lanislab.co.za
DNS: installed on the DC with the lanislab.co.za forward lookup zone
Forest/Domain Functional Level: Windows Server 2025
Recycle Bin: enabled
Test users: John Maleka, Sarah Chauke, Theo Baloyi, Sammuel Mathebula, Thabo Nkosi, Lerato Dlamini, Sipho Khumalo, Nomsa Mahlangu, Pieter van Wyk
Test computer object: TEST-PC01
Groups: Sales Team, IT Team, All Staff, Junior Techs, Company Announcements (Distribution)


Screenshots

All screenshots are in the screenshots folder. See screenshots/README.md for a numbered index.
