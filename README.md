# Nerdio Scripted Actions Collection

This repository contains curated and reusable PowerShell scripts optimized for use as **Scripted Actions** within Nerdio Manager for Enterprise (NME) and Nerdio Manager for MSP (NMM).

Each script can be used to automate common post-provisioning or maintenance tasks across Azure Virtual Machines and Windows hosts.

---

## 📚 Available Scripts

| Script Name | Purpose | OS | Parameters |
|:------------|:--------|:---|:-----------|
| [Extend Disk Partition](./extend-disk-partition/extend-disk-partition.ps1) | Extend an existing partition to use all available unallocated space. | Windows | DriveLetter, MinimumSizeGB |


General Steps:

Go to Scripted Actions > Windows Scripts in Nerdio Manager.

Click Add Scripted Action.

Paste the script content from the corresponding .ps1 file.

Fill in metadata (Name, Description, Execution Context = System).

Enable "This script has parameters" if applicable.

⚙️ Parameters
Some scripts are designed with parameters for flexibility.

Default values are provided where appropriate.

Parameters can be overridden at runtime when assigning Scripted Actions to deployments.

✍️ Contributing
Feel free to fork and submit pull requests if you have improvements or new Scripted Actions to contribute!

📄 License
This repository is licensed under the MIT License.

👨‍💻 Maintainer
Blackduke77
