#!/usr/bin/env pwsh
# sync-lectures.ps1 - Sync lectures fork with upstream repository

Write-Host "Syncing lectures fork with upstream repository..." -ForegroundColor Cyan

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

# Fetch upstream changes
Write-Host "Fetching upstream changes..." -ForegroundColor Yellow
git fetch upstream

# Check current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Blue

# Merge upstream changes
Write-Host "Merging upstream changes..." -ForegroundColor Yellow
git merge upstream/main

# Push to your fork
Write-Host "Pushing to your fork..." -ForegroundColor Yellow
git push origin $currentBranch

Write-Host "Lectures fork sync complete!" -ForegroundColor Green
Write-Host "Latest lectures are now available in your repository." -ForegroundColor Green

# Show summary of changes
Write-Host "Recent commits from upstream:" -ForegroundColor Blue
git log --oneline -5 upstream/main
