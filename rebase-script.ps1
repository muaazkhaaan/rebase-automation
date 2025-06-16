#requires -PSEdition Core

# Set up
$targetBranch = "release-muaaz"
$allowList = @("devops-academy-one", "devops-academy-two")

# Process each repo (if allowed)
Get-ChildItem -Path . -Directory -Recurse | Where-Object {
    Test-Path "$($_.FullName)\.git"
} | ForEach-Object {
    $repoPath = $_.FullName
    $repoName = $_.Name

    if ($allowList -contains $repoName) {
        Write-Host "`n--- Processing repository: $repoName ---" -ForegroundColor Cyan

        try {
            Push-Location $repoPath

            # Step 1: Checkout main and pull latest changes
            Write-Host "Switching to 'main' branch..." -ForegroundColor Yellow
            git checkout main
            git pull

            # Step 2: Check if target branch exists
            $localBranches = git branch --list $targetBranch
            $remoteBranches = git branch -r | Select-String "origin/$targetBranch"

            if (-not $localBranches -and -not $remoteBranches) {
                Write-Host "Target branch '$targetBranch' doesn't exist. Creating from 'release-template'..." -ForegroundColor Magenta
                git checkout -b $targetBranch origin/release-template
            } else {
                Write-Host "Checking out '$targetBranch'..." -ForegroundColor Yellow
                git checkout $targetBranch
            }

            # Step 3: Pull latest changes on target
            git pull

            # Step 4: Rebase target branch onto main
            Write-Host "Rebasing '$targetBranch' onto 'main'..." -ForegroundColor Yellow
            git rebase main

            # Step 5: Push if rebase successful
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Rebase successful. Pushing '$targetBranch' to origin..." -ForegroundColor Green
                git push -f origin HEAD
            } else {
                Write-Error "Rebase failed for $repoName"
            }
        }
        catch {
            Write-Error "ERROR processing $repoName : $($_.Exception.Message)"
        }
        finally {
            Pop-Location
        }
    }
}