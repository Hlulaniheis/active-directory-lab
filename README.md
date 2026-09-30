# Active Directory Lab — Windows Server 2025

A hands-on Active Directory lab built on **Windows Server 2025**, demonstrating the day-to-day tasks a Tier 1 / Tier 2 IT Technician or Junior Sysadmin performs: user lifecycle management, group nesting, GPO configuration, offboarding, AD Recycle Bin recovery, stale object auditing, OU delegation, and PowerShell automation.

| | |
|---|---|
| **Domain** | `lanislab.co.za` |
| **NetBIOS** | `LANISLAB` |
| **Forest / Domain Functional Level** | Windows Server 2025 |
| **Domain Controller** | `vm-hyperv-host.lanislab.co.za` |

---

## Tech Stack

- **Windows Server 2025** — Domain Controller, DNS, Hyper-V host
- **Active Directory Domain Services (AD DS)**
- **Group Policy Management** (GPMC / GPME)
- **PowerShell 5.1** — AD module, `Search-ADAccount`, `New-ADUser`, `Unlock-ADAccount`, plus custom scripts
- **CMD tools** — `netdom`, `gpupdate`

---

## Tasks Completed

### User Lifecycle

| Task | Method | Evidence |
|------|--------|----------|
| Create user from scratch | ADUC GUI | [02](screenshots/02-create-user-johnmaleka.png), [03](screenshots/03-aduc-user-created.png) |
| Create user by copying a template | ADUC Copy wizard | [11–19](screenshots/) |
| Bulk create users from CSV | PowerShell `New-ADUser` | [20–23](screenshots/22-bulk-create-success.png) |
| Unlock a locked user account | `Unlock-ADAccount` | [10](screenshots/10-lockout-and-unlock-johnmaleka.png) |
| Modify UPN suffix after a company merger | AD Domains & Trusts + ADUC | [24–25](screenshots/24-upn-suffix-added.png) |

### Groups & Permissions

| Task | Method | Evidence |
|------|--------|----------|
| Create Security vs Distribution groups | ADUC | [14](screenshots/14-create-sales-team-group.png), [26](screenshots/26-create-company-announcements-distribution.png) |
| Nested group membership (Sales Team → All Staff) | ADUC Members tab | [31](screenshots/31-all-staff-members-tab-populated.png) |
| Find all groups a user belongs to (including nested) | Custom PowerShell recursion | [28–30](screenshots/30-nested-groups-error-then-fix.png) |
| Export all group members to CSV | `Get-ADGroupMember -Recursive` + `Export-Csv` | [33–34](screenshots/33-adgroupmember-recursive-and-csv-export.png) |

### Group Policy

| Task | Method | Evidence |
|------|--------|----------|
| Configure account lockout policy (5 attempts, 15 min) | GPME → Default Domain Policy | [05–08](screenshots/08-lockout-policy-final.png) |
| Force policy update | `gpupdate /force` | [09](screenshots/09-gpupdate-force.png) |

### Offboarding & Recovery

| Task | Method | Evidence |
|------|--------|----------|
| Disable, reset password, strip groups, move to Disabled Users OU | PowerShell | [38](screenshots/38-offboard-theo-commands.png) |
| Enable AD Recycle Bin | `Enable-ADOptionalFeature` | [41](screenshots/41-enable-recycle-bin.png) |
| Delete a user and restore from Recycle Bin | `Remove-ADUser` + `Restore-ADObject` | [44](screenshots/44-recycle-bin-restore-sammuel.png) |

### Computer Objects & Auditing

| Task | Method | Evidence |
|------|--------|----------|
| Create and move a computer object between OUs | `Move-ADObject` | [50](screenshots/50-move-test-pc01-to-laptops.png) |
| Find & disable stale computers (last logon > 90 days) | `LastLogonTimeStamp` + `Set-ADComputer` | [52–53](screenshots/53-stale-computer-disable-worked.png) |
| Audit inactive accounts | `Search-ADAccount -AccountInactive` | [54–55](screenshots/54-search-adaccount-inactive.png) |

### Delegation & FSMO

| Task | Method | Evidence |
|------|--------|----------|
| Delegate OU control to a junior tech group | Delegation of Control Wizard | [56–59](screenshots/58-delegate-wizard-tasks.png) |
| Identify FSMO role holders | `netdom query fsmo` | [62](screenshots/62-fsmo-query.png) |

---

## Scripts

Custom PowerShell scripts written for this lab are in the [`scripts/`](scripts/) folder:

- **`BulkCreateUsers.ps1`** — imports a CSV and provisions users with department, title, and UPN attributes
- **`Get-NestedGroups.ps1`** — recursively walks group membership upward using a queue, returning all direct and nested groups for a user

---

## What I Learned

- **`LastLogonTimeStamp` is a raw Int64.** It must be converted with `[DateTime]::FromFileTime()` before comparison. `Search-ADAccount` does this automatically.
- **`Disable-ADAccount` doesn't always resolve computer objects by SamAccountName.** `Set-ADComputer -Enabled $false` is more reliable.
- **AD Recycle Bin must be enabled *before* deletion** for a clean restore. Otherwise you fall back to the messier LDP tombstone-reanimation method.
- **Group nesting directions matter.** The *Members* tab shows what's inside a group; the *Member Of* tab shows what a group belongs to. Mixing them up leads to silent misconfigurations.
- **Delegation modifies an OU's ACL**, not group membership — a junior tech can get password-reset rights on one OU without any Domain Admin rights.

---

## Lab Environment

- **Host:** Azure VM running Windows Server 2025 with Hyper-V
- **Domain Controller:** `vm-hyperv-host.lanislab.co.za`
- **DNS:** installed on the DC (`lanislab.co.za` forward lookup zone)
- **Forest / Domain Functional Level:** Windows Server 2025
- **Recycle Bin:** enabled
- **Test users:** John Maleka, Sarah Chauke, Theo Baloyi, Sammuel Mathebula, Thabo Nkosi, Lerato Dlamini, Sipho Khumalo, Nomsa Mahlangu, Pieter van Wyk
- **Test computer object:** `TEST-PC01`
- **Groups:** Sales Team, IT Team, All Staff, Junior Techs, Company Announcements (Distribution)

---

## Screenshots

All screenshots are in the [`screenshots/`](screenshots/) folder. See [`screenshots/README.md`](screenshots/README.md) for a numbered index.
