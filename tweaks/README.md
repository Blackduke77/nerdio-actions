# Tweaks

Scripts that adjust Windows system or user environment settings inside Azure VMs.

---

## 📚 Available Scripts

| Script Name | Purpose | Parameters |
|:------------|:--------|:-----------|
| enable-entra-authentication-for-rdp.ps1| suppressing single sign-on (SSO) consent prompts for Azure Virtual Desktop (AVD) and Windows 365 | Group ID and Group Name to be updated in script ($tdg.Id $tdg.DisplayName)  |

---

## 🚀 Usage

- Add as a Scripted Action during image build or post-deployment.
- Set the Execution Context to **System**.
