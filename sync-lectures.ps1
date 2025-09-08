#!/usr/bin/env pwsh
# sync-lectures.ps1 - Sync lectures fork with upstream repository

Write-Host "🔄 Syncing lectures fork with upstream repository..." -ForegroundColor Cyan

# Navigate to repo root
$repoRoot = "c:\Users\billn\Downloads\CHEM4800\CHEME-5800-Lectures-Fall-2025-1"
Set-Location $repoRoot

# Fix git ownership issue if needed
try {
    $safeDirectoryCheck = git config --global --get-all safe.directory 2>$null | Select-String "CHEME-5800-Lectures-Fall-2025-1"
    if (-not $safeDirectoryCheck) {
        Write-Host "🔧 Fixing git ownership issue..." -ForegroundColor Yellow
        git config --global --add safe.directory $repoRoot
    }
}
catch {
    Write-Host "🔧 Fixing git ownership issue..." -ForegroundColor Yellow
    git config --global --add safe.directory $repoRoot
}

# Check if upstream remote exists, if not add it
$upstreamExists = git remote 2>$null | Select-String "upstream"
if (-not $upstreamExists) {
    Write-Host "➕ Adding upstream remote..." -ForegroundColor Yellow
    git remote add upstream https://github.com/varnerlab/CHEME-5800-Lectures-Fall-2025.git
}

# Fetch upstream changes
Write-Host "📥 Fetching upstream changes..." -ForegroundColor Yellow
git fetch upstream

# Check current branch
$currentBranch = git branch --show-current
Write-Host "📍 Current branch: $currentBranch" -ForegroundColor Blue

# Merge upstream changes
Write-Host "🔄 Merging upstream changes..." -ForegroundColor Yellow
git merge upstream/main 2>&1 | Out-Null

# Check if there are conflicts
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Merge conflicts detected. Resolving..." -ForegroundColor Yellow
    
    # Get list of conflicted files
    $conflictedFiles = git diff --name-only --diff-filter=U
    
    foreach ($file in $conflictedFiles) {
        # For lectures, we typically want upstream version unless it's your personal notes
        if ($file -like "*notes*" -or $file -like "*personal*" -or $file -like "*my-*") {
            Write-Host "📝 Keeping your version of: $file" -ForegroundColor Yellow
            git checkout --ours $file
            git add $file
        } else {
            Write-Host "⚡ Taking upstream version of: $file" -ForegroundColor Yellow
            git checkout --theirs $file
            git add $file
        }
    }
    
    # Complete the merge
    git commit -m "Merge upstream lecture updates, preserving personal notes"
}

# Push to your fork
Write-Host "📤 Pushing to your fork..." -ForegroundColor Yellow
git push origin $currentBranch

Write-Host "✅ Lectures fork sync complete!" -ForegroundColor Green
Write-Host "Latest lectures are now available in your repository." -ForegroundColor Green

# Show summary of changes
Write-Host "`n📊 Recent commits from upstream:" -ForegroundColor Blue
git log --oneline -5 upstream/main
