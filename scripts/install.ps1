# installs the latest release for Windows amd64. no Go required.
# usage: powershell -c "irm https://raw.githubusercontent.com/sahithyandev/go-cli-template/main/scripts/install.ps1 | iex"
#
# rename the repo and binary variables below when adapting this template.
$ErrorActionPreference = "Stop"

$repo = "sahithyandev/go-cli-template"
$binary = "app"

$release = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest"
$tag = $release.tag_name
$version = $tag.TrimStart("v")
$archive = "${binary}_${version}_windows_amd64.zip"
$url = "https://github.com/$repo/releases/download/$tag/$archive"

$tmp = Join-Path $env:TEMP $archive
Write-Host "downloading $url"
Invoke-WebRequest -Uri $url -OutFile $tmp

$dest = Join-Path $env:LOCALAPPDATA $binary
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Expand-Archive -Path $tmp -DestinationPath $dest -Force
Remove-Item $tmp

Write-Host "installed $binary $version to $dest\$binary.exe"
if (($env:Path -split ";") -notcontains $dest) {
	Write-Host "add $dest to your PATH to run '$binary' directly"
}
