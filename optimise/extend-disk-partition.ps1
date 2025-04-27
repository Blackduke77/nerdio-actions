<#
.SYNOPSIS
Extends a specified disk partition to use all available unallocated space on an Azure VM.

.DESCRIPTION
This script is intended for use as a Nerdio Manager Scripted Action.
It detects the current size of the target disk and expands the partition to its maximum supported size
if the total disk size exceeds a configurable minimum threshold.

.PARAMETER DriveLetter
The drive letter of the partition to extend. (Default: C)

.PARAMETER MinimumSizeGB
The minimum disk size (in GB) required before extension is attempted. (Default: 128)

.NOTES
Execution Context: System
Intended for Azure Windows VMs managed via Nerdio Manager.
Tested with Windows Server and Windows 10/11.
#>

param (
    [string]$DriveLetter = "C",
    [int]$MinimumSizeGB = 128
)

try {
    Write-Output "Starting disk extension script..."
    Write-Output "Target Drive: $DriveLetter:"
    Write-Output "Minimum required size: $MinimumSizeGB GB"

    $partition = Get-Partition -DriveLetter $DriveLetter -ErrorAction Stop
    $volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction Stop
    $size = Get-PartitionSupportedSize -DriveLetter $DriveLetter -ErrorAction Stop

    $diskSizeGB = [math]::Round($volume.Size / 1GB, 0)

    Write-Output "Detected disk size: $diskSizeGB GB"

    if ($diskSizeGB -gt $MinimumSizeGB) {
        if ($partition.Size -lt $size.SizeMax) {
            Write-Output "Extending partition $DriveLetter..."
            Resize-Partition -DriveLetter $DriveLetter -Size $size.SizeMax -ErrorAction Stop
            Write-Output "Partition $DriveLetter extended successfully to match $diskSizeGB GB disk."
        }
        else {
            Write-Output "Partition $DriveLetter already uses full disk space. No resizing needed."
        }
    }
    else {
        Write-Output "Disk size ($diskSizeGB GB) is less than or equal to $MinimumSizeGB GB. No action taken."
    }
}
catch {
    Write-Error "Failed to extend partition $DriveLetter: $_"
}
