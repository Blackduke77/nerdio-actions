# Nerdio Scripted Actions Collection

![License](https://img.shields.io/github/license/Blackduke77/nerdio-actions?style=flat-square)
![PowerShell](https://img.shields.io/badge/Language-PowerShell-blue?style=flat-square)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?style=flat-square)
![Nerdio Manager](https://img.shields.io/badge/Nerdio-Supported-blueviolet?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/Blackduke77/nerdio-actions?style=flat-square)

---

Welcome to the **Nerdio Scripted Actions Collection**!

This repository contains curated and reusable PowerShell scripts optimized for use within [Nerdio Manager for Enterprise (NME)]([https://getnerdio.com/nerdio-manager-enterprise](https://getnerdio.com/nerdio-manager/enterprise) and [Nerdio Manager for MSP (NMM)](https://getnerdio.com/nerdio-manager/msp/).

Each script is designed to automate common post-provisioning, maintenance, and management tasks for Azure Virtual Machines and Windows hosts.

---

## 📚 Available Scripts

| Script Name | Purpose | OS | Parameters |
|:------------|:--------|:---|:-----------|
| [Extend Disk Partition](./extend-disk-partition/extend-disk-partition.ps1) | Extends an existing partition to use all available unallocated disk space. Useful after resizing OS or data disks. | Windows | DriveLetter, MinimumSizeGB |

---

## 🛠 Usage Instructions

Each script is designed to be pasted into Nerdio Manager's **Scripted Actions** section.

**General steps to add a script:**

1. Navigate to **Scripted Actions** > **Windows Scripts** in Nerdio Manager.

2. Click **Add Scripted Action**.

3. Copy the script content from the corresponding `.ps1` file in this repository.

4. Paste it into the Nerdio Scripted Action editor.

5. Fill in metadata fields such as Name, Description, Operating System (Windows), and Execution Context (System).

6. Enable **"This script has parameters"** if applicable.

---

## ⚙️ Parameters

- **DriveLetter** (string, default `"C"`):  
  The drive letter to target for extension (e.g., `C`, `D`, `E`).

- **MinimumSizeGB** (integer, default `128`):  
  Minimum disk size (in GB) required before attempting to extend the partition.

Parameters can be adjusted at runtime when assigning Scripted Actions to VM deployments.

---

## ✍️ Contributing

Contributions are welcome!

- Submit an Issue to suggest a script improvement or new script idea.
- Fork the repository, make changes, and submit a Pull Request (PR) for review.

Please follow the existing structure when adding new scripts.

---

## 📄 License

This project is licensed under the [MIT License](https://github.com/Blackduke77/nerdio-actions/blob/main/LICENSE).

You are free to use, modify, and distribute these scripts under the terms of the license.

---

## 👨‍💻 Maintainer

- Blackduke77

---

## 🔥 Repository Structure Example

```text
nerdio-actions/
│
├── extend-disk-partition/
│   ├── extend-disk-partition.ps1
│   ├── README.md
│
├── another-script/
│   ├── another-script.ps1
│   ├── README.md
│
├── README.md   <-- (this file)
