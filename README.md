# Rebase Automation Script

This PowerShell script automates the process of syncing a personal release branch with the latest changes from the `main` branch across multiple Git repositories.

## What It Does

For each allowed repository in a specified folder:

1. Switches to the `main` branch and pulls the latest changes.
2. Switches to your personal release branch (`release-muaaz`). If it doesn't exist, it creates it from `release-template`.
3. Pulls the latest changes on your release branch.
4. Rebases your release branch onto `main`.
5. If the rebase is successful, it force pushes the updated branch back to GitHub.


## How to Use

1. Clone this repo or copy the script into your working folder.
2. Open PowerShell Core.
3. Navigate to the folder containing the script.
4. Run the script:

```powershell
.\your-script-name.ps1
