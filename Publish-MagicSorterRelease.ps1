# Packs MagicSorter/ and publishes the matching changelog section.
# Local:  .\Publish-MagicSorterRelease.ps1
#         .\Publish-MagicSorterRelease.ps1 -Tag v30
# GitHub: push a tag v30. .github/workflows/release.yml runs this script.
param(
    [string] $Tag,
    [switch] $SkipTag
)

$ErrorActionPreference = "Stop"
$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repositoryRoot

function Get-AddonVersion {
    $addonPath = Join-Path $repositoryRoot "MagicSorter\MagicSorter.addon"
    $addonText = Get-Content -Path $addonPath -Raw
    $versionMatch = [regex]::Match($addonText, "(?m)^## Version:\s*(\d+)\s*$")
    $addonVersionMatch = [regex]::Match($addonText, "(?m)^## AddOnVersion:\s*(\d+)\s*$")
    if (-not $versionMatch.Success -or -not $addonVersionMatch.Success) {
        throw "MagicSorter.addon is missing ## Version or ## AddOnVersion."
    }
    if ($versionMatch.Groups[1].Value -ne $addonVersionMatch.Groups[1].Value) {
        throw "Version $($versionMatch.Groups[1].Value) does not match AddOnVersion $($addonVersionMatch.Groups[1].Value)."
    }
    return $versionMatch.Groups[1].Value
}

function Get-ChangelogSection {
    param([string] $Version)
    $changelogPath = Join-Path $repositoryRoot "changelog.md"
    $lines = Get-Content -Path $changelogPath
    $sectionLines = New-Object System.Collections.Generic.List[string]
    $inSection = $false
    foreach ($line in $lines) {
        if ($line -match "^## \[$Version\]") {
            $inSection = $true
            continue
        }
        if ($inSection -and $line -match "^## \[") {
            break
        }
        if ($inSection) {
            $sectionLines.Add($line)
        }
    }
    $sectionText = ($sectionLines -join "`n").Trim()
    if (-not $sectionText) {
        throw "changelog.md has no section ## [$Version]."
    }
    return $sectionText
}

$addonVersion = Get-AddonVersion
if (-not $Tag) {
    $Tag = "v$addonVersion"
}
$tagVersion = $Tag -replace "^v", ""
if ($tagVersion -ne $addonVersion) {
    throw "Tag $Tag does not match addon version $addonVersion."
}

$releaseNotes = Get-ChangelogSection -Version $addonVersion
$notesPath = Join-Path $repositoryRoot "MagicSorter-$Tag-notes.md"
$zipPath = Join-Path $repositoryRoot "MagicSorter-$Tag.zip"
Set-Content -Path $notesPath -Value $releaseNotes -Encoding utf8
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}
Compress-Archive -Path (Join-Path $repositoryRoot "MagicSorter") -DestinationPath $zipPath

if (-not $SkipTag) {
    $existingTag = git tag --list $Tag
    if (-not $existingTag) {
        git tag $Tag
    }
    git push origin $Tag
}

gh release create $Tag $zipPath --title "Version $addonVersion" --notes-file $notesPath
Remove-Item $notesPath -Force
Write-Output "Published $Tag with $zipPath"
