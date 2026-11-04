param(
    [string]$Repo = (Split-Path -Parent $PSScriptRoot),
    [string]$OutDir = (Join-Path (Split-Path -Parent $PSScriptRoot) 'dist')
)
# Builds an Agent Plugins 1.0 package (manifest + skills/) from plugins/<role>. Sources are not modified.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$src = Get-ChildItem (Join-Path $Repo 'plugins') -Directory | Select-Object -First 1
$meta = Get-Content (Join-Path $src.FullName 'plugin.json') -Raw | ConvertFrom-Json
$stage = Join-Path $env:TEMP ("pkg-stage-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
$manifest = [ordered]@{ '$schema' = 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json'; name = $meta.name; version = $meta.version; description = $meta.description }
[IO.File]::WriteAllText("$stage\plugin.json", (($manifest | ConvertTo-Json) + "`n"), $utf8)
Copy-Item (Join-Path $src.FullName 'skills') "$stage\skills" -Recurse
$problems = @()
Get-ChildItem $stage -Recurse -Filter *.json | ForEach-Object { try { Get-Content $_.FullName -Raw | ConvertFrom-Json | Out-Null } catch { $problems += "invalid JSON: $($_.FullName)" } }
Get-ChildItem "$stage\skills" -Recurse -File | ForEach-Object { if ((Get-Content $_.FullName -Raw) -match '\(\.\./|"\$ref":\s*"\.\./|`\.\./') { $problems += "path escapes package: $($_.FullName.Replace($stage,''))" } }
if ($meta.name -notmatch '^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$' -or $meta.name -match '--|\.\.' -or $meta.name.Length -gt 64) { $problems += "invalid plugin name: $($meta.name)" }
$skills = Get-ChildItem "$stage\skills" -Directory
if ($skills.Count -ne 1) { $problems += 'plugin must contain exactly one skill' }
foreach ($s in $skills) { if ((Get-Content "$($s.FullName)\SKILL.md" -Raw) -notmatch "(?m)^name: $($s.Name)\s*$") { $problems += "SKILL.md name does not match folder $($s.Name)" } }
if ($problems.Count) { $problems | ForEach-Object { Write-Error $_ -ErrorAction Continue }; Remove-Item $stage -Recurse -Force; exit 2 }
New-Item -ItemType Directory -Force $OutDir | Out-Null
$zipPath = Join-Path $OutDir ("$($meta.name)-$($meta.version).zip")
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::Open($zipPath, 'Create')
try { Get-ChildItem $stage -Recurse -File | Sort-Object FullName | ForEach-Object { [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $_.FullName.Substring($stage.Length + 1).Replace('\','/'), 'Optimal') | Out-Null } } finally { $zip.Dispose() }
Remove-Item $stage -Recurse -Force
"BUILT $zipPath"