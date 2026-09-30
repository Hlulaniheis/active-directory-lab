function Get-AllGroups {
    param(
        [Parameter(Mandatory)]
        [string]$Username
    )

    $DirectGroups = Get-ADUser -Identity $Username -Properties MemberOf |
        Select-Object -ExpandProperty MemberOf

    $AllGroups = New-Object System.Collections.Generic.HashSet[string]
    $Queue = New-Object System.Collections.Generic.Queue[string]

    foreach ($g in $DirectGroups) { $Queue.Enqueue($g) }

    while ($Queue.Count -gt 0) {
        $Current = $Queue.Dequeue()
        if ($AllGroups.Add($Current)) {
            $ParentGroups = (Get-ADGroup -Identity $Current -Properties MemberOf).MemberOf
            foreach ($p in $ParentGroups) { $Queue.Enqueue($p) }
        }
    }

    $AllGroups | ForEach-Object { (Get-ADGroup $_).Name } | Sort-Object
}

Get-AllGroups -Username "sarahchauke"
