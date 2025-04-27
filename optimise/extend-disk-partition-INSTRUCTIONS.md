# Extend Disk Partition - Instructions

This page explains how to use the **Extend Disk Partition** script inside Nerdio Manager.

---

## 🛠 Nerdio Manager Settings

When adding the script as a Scripted Action:

| Setting | Value |
|:--------|:------|
| **Script Name** | Extend Disk Partition |
| **Description** | Extends a disk partition to use all available unallocated space if disk size exceeds a minimum threshold. |
| **Execution Moded** | Combined |
| **Operating System** | Windows |
| **Has Parameters** | Yes |

---

## ⚙️ Script Parameters

| Parameter | Type | Default | Description |
|:----------|:-----|:--------|:------------|
| `DriveLetter` | String | `C` | The drive letter to target for extension (e.g., `C`, `D`). |
| `MinimumSizeGB` | Integer | `128` | Minimum disk size (in GB) required before attempting to extend the partition. |

**Note:** Parameters can be customized when assigning the Scripted Action to a VM.

---

## 🚀 Suggested Use Cases

- After resizing an Azure VM OS disk.
- After adding a larger data disk to a VM.
- During the auto-scaling process for session hosts.
- As part of a post-provisioning step for VM builds.

---

## 🧠 Important Notes

- The partition must already exist. This script does **not** create new partitions.
- If the partition already uses all available space, the script will detect and skip extension safely.
- Always ensure a VM reboot is scheduled if other partition-related scripts are run afterwards.

---

