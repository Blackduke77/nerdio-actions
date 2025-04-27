---

## 🧠 Instructions for Extend Disk Partition Script

This script should be added to Nerdio Manager as a Windows Scripted Action.

### Nerdio Manager Settings
- **Execution Context**: System
- **Operating System**: Windows
- **Has Parameters**: Yes

### Default Parameters
- `DriveLetter`: C
- `MinimumSizeGB`: 128

### Suggested Use Cases
- Run after resizing Azure VM OS disks.
- Run after attaching larger data disks to a VM.
- Include during the auto-scaling process for Session Hosts.
- Attach as a Post-Provisioning Scripted Action on Windows desktop images.

### Suggested Assignment in Nerdio
- During VM creation (Create Desktop Image, Provision Host Pools)
- As a Post-Resize Action for scaled up VMs
- As a Manual Repair Script for VMs with incorrect disk partition size

---

## Example Nerdio Scripted Action Settings

| Setting | Value |
|:--------|:------|
| Script Name | Extend Disk Partition |
| Description | Extends a disk partition to use all available disk space if total disk size exceeds a minimum threshold. |
| Execution Context | System |
| OS Type | Windows |
| Script Parameters | DriveLetter, MinimumSizeGB |

---
