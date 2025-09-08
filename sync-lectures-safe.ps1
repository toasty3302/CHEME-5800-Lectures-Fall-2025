#!/usr/bin/env pwsh
# sync-lectures-safe.ps1 - Safely sync lectures fork with upstream repository
# This script preserves your local changes and handles conflicts gracefully

Write-Host "Safely syncing lectures fork with upstream repository..." -ForegroundColor Cyan

# Navigate to repo root
$repoRoot = "c:\Users\billn\Downloads\CHEM4800\CHEME-5800-Lectures-Fall-2025-1"
Set-Location $repoRoot

# Fix git ownership issue
Write-Host "Fixing git ownership issue..." -ForegroundColor Yellow
git config --global --add safe.directory $repoRoot

# Check if upstream remote exists, if not add it
$upstreamExists = git remote | Select-String "upstream"
if (-not $upstreamExists) {
    Write-Host "Adding upstream remote..." -ForegroundColor Yellow
    git remote add upstream https://github.com/varnerlab/CHEME-5800-Lectures-Fall-2025.git
}

# Get current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Blue

# Create a backup branch with timestamp
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupBranch = "backup-before-sync-$timestamp"
Write-Host "Creating backup branch: $backupBranch" -ForegroundColor Yellow
git branch $backupBranch

# Check for uncommitted changes
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "Found uncommitted changes. Committing them first..." -ForegroundColor Yellow
    Write-Host "Changed files:" -ForegroundColor Gray
    git status --short
    
    # Add all changes
    git add -A
    
    # Create a commit with timestamp
    $commitMessage = "Auto-commit before sync - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $commitMessage
    Write-Host "Committed changes with message: $commitMessage" -ForegroundColor Green
} else {
    Write-Host "No uncommitted changes found." -ForegroundColor Green
}

# Fetch upstream changes
Write-Host "Fetching upstream changes..." -ForegroundColor Yellow
git fetch upstream

# Check if there are any upstream changes
$localCommit = git rev-parse HEAD
$upstreamCommit = git rev-parse upstream/main
if ($localCommit -eq $upstreamCommit) {
    Write-Host "Already up to date with upstream!" -ForegroundColor Green
    exit 0
}

# Show what changes will be merged
Write-Host "New commits from upstream:" -ForegroundColor Blue
git log --oneline HEAD..upstream/main

# Attempt to merge upstream changes
Write-Host "Merging upstream changes..." -ForegroundColor Yellow
git merge upstream/main

# Check if merge was successful
$mergeConflicts = git status --porcelain | Where-Object { $_ -match "^UU" }
if ($mergeConflicts) {
    Write-Host "MERGE CONFLICTS DETECTED!" -ForegroundColor Red
    Write-Host "Files with conflicts:" -ForegroundColor Red
    git status --short | Where-Object { $_ -match "^UU" }
    
    Write-Host "`nTo resolve conflicts:" -ForegroundColor Yellow
    Write-Host "1. Open the conflicted files in VS Code" -ForegroundColor White
    Write-Host "2. Resolve conflicts using VS Code's merge editor" -ForegroundColor White
    Write-Host "3. Run: git add <resolved-files>" -ForegroundColor White
    Write-Host "4. Run: git commit" -ForegroundColor White
    Write-Host "5. Run: git push origin $currentBranch" -ForegroundColor White
    
    Write-Host "`nYour backup branch '$backupBranch' is available if needed." -ForegroundColor Cyan
    exit 1
}

# If merge was successful, push to your fork
Write-Host "Merge successful! Pushing to your fork..." -ForegroundColor Yellow
git push origin $currentBranch

Write-Host "Lectures fork sync complete!" -ForegroundColor Green
Write-Host "Latest lectures are now available and your changes are preserved." -ForegroundColor Green

# Show summary
Write-Host "`nSummary:" -ForegroundColor Blue
Write-Host "- Backup branch created: $backupBranch" -ForegroundColor White
Write-Host "- Your changes: Preserved and committed" -ForegroundColor White
Write-Host "- Upstream changes: Merged successfully" -ForegroundColor White
Write-Host "- Repository: Up to date" -ForegroundColor White

# Cleanup old backup branches (keep last 5)
Write-Host "`nCleaning up old backup branches..." -ForegroundColor Yellow
$backupBranches = git branch | Select-String "backup-before-sync-" | ForEach-Object { $_.ToString().Trim() }
if ($backupBranches.Count -gt 5) {
    $branchesToDelete = $backupBranches | Select-Object -First ($backupBranches.Count - 5)
    foreach ($branch in $branchesToDelete) {
        git branch -D $branch
        Write-Host "Deleted old backup branch: $branch" -ForegroundColor Gray
    }
}
