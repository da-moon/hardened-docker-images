# syntax = docker/dockerfile:labs
# escape=`
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────
# hadolint ignore=DL3007
FROM cgr.dev/chainguard/powershell:latest

SHELL [ "/usr/bin/pwsh" ,"-NoLogo","-NoProfile","-Command"]

ENV POWERSHELL_TELEMETRY_OPTOUT="1"
ENV ErrorActionPreference="Stop"
ENV ProgressPreference="SilentlyContinue"

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV USER="nonroot"
ENV HOME="/home/${USER}"

ARG POWERCLI_VERSION="13.2.1.22851661"
WORKDIR "${HOME}"

# https://www.powershellgallery.com/packages/BuildHelpers/0.0.28/Content/Public%5CFind-NugetPackage.ps1
# https://gist.github.com/jborean93/e0cb0e3aabeaa1701e41f2304b023366
RUN `
# ────────────────────────────────────────────────────────────────────────────────
$ErrorActionPreference = "$Env:ErrorActionPreference" ; `
$ProgressPreference = "$Env:ProgressPreference" ; `
$CURRENT_USERS_PSPATH = Split-Path -Path ([System.Management.Automation.Platform]::SelectProductNameForDirectory('USER_MODULES')) -Parent ; `
$PSModulePath = Join-Path -Path $CURRENT_USERS_PSPATH -ChildPath 'Modules' ; `

# NOTE: recursive copy
Function Copy-FolderContents { `
  Param ($Path, $DestinationPath, $IgnoredFiles = @()) `
  $path_items = Get-ChildItem -LiteralPath $Path ; `
  foreach ($path_item in $path_items) { `
      if ($path_item.Name -in $IgnoredFiles) { `
          continue ; `
      } ; `
      $dest_path = Join-Path -Path $DestinationPath -ChildPath $path_item.Name; `
      if ($path_item.PSIsContainer) { `
          New-Item -Path $dest_path -ItemType Directory -Force > $null ; `
          Copy-FolderContents -Path $path_item.FullName -DestinationPath $dest_path ; `
      } else { `
        Copy-Item -LiteralPath $path_item.FullName -Destination $dest_path -Force ; `
      } ; `
  } ; `
} ; `
# ────────────────────────────────────────────────────────────────────────────────
Function Install-Module { `
  Param ($ModuleName, $ModuleVersion = @()) `
    $URI = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName' and Version eq '$ModuleVersion'" ; `
  # $URI = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName' and IsLatestVersion"
  $URL = Invoke-RestMethod $URI -ErrorAction Stop `
  | Select-Object @{n='Name';ex={$_.title.('#text')}}, `
                  @{n='Author';ex={$_.author.name}}, `
                  @{n='Version';ex={$_.properties.NormalizedVersion}}, `
                  @{n='Uri';ex={$_.Content.src}}, `
                  @{n='Description';ex={$_.properties.Description}}, `
                  @{n='Properties';ex={$_.properties}} `
  | Select-Object -ExpandProperty Uri ; `
  $FilePath="$($Env:HOME)/$($ModuleName).zip" ; `
  Invoke-WebRequest `
    -Uri "$URL" `
    -OutFile "$FilePath" `
    -UseBasicParsing ; `
  $temp_folder = "$($Env:HOME)/tmp" ; `
  [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $temp_folder); `
  Remove-Item -LiteralPath $FilePath -Force ; `

  $nuspec_file = Get-Item -Path (Join-Path -Path $temp_folder -ChildPath '*.nuspec') ; `
  $package_nuspec = [System.Xml.XmlDocument](Get-Content -LiteralPath $nuspec_file.FullName -Raw -ErrorAction Stop) ; `
  $name = $package_nuspec.package.metadata.id ; `
  $version = $package_nuspec.package.metadata.version ; `
  if ($version -ne $ModuleVersion) { $version=$ModuleVersion } ; `
  $module_path = Join-Path -Path $PSModulePath -ChildPath $name ; `
  $module_path = Join-Path -Path $module_path -ChildPath $version ;  `
  if (-not (Test-Path -LiteralPath $module_path)) { New-Item -Path $module_path -ItemType Directory > $null } ; `
  # NOTE: Ignore these files in the .nupkg, we don't care or need them.
  $ignored_files = @("$name.nuspec", '[Content_Types].xml', '_rels', 'package') ; `
  Copy-FolderContents -Path $temp_folder -DestinationPath $module_path -IgnoredFiles $ignored_files ; `
  Remove-Item -LiteralPath $temp_folder -Force -Recurse ; `
  Get-Module -Name $module_path -ListAvailable ; `
}; `
# ────────────────────────────────────────────────────────────────────────────────
  Install-Module -ModuleName "VMware.PowerCLI" -ModuleVersion "$($Env:POWERCLI_VERSION)" ; `
  $POWERCLI_PSD1 = "$(Get-Module -Name "VMware.PowerCLI" -ListAvailable | Select-Object -ExpandProperty ModuleBase)/VMware.PowerCLI.psd1" ; `
  $config = Import-PowerShellDataFile -Path $POWERCLI_PSD1 ; `
  foreach ($elem in $config.RequiredModules) { `
    Install-Module -ModuleName $elem.ModuleName -ModuleVersion $elem.ModuleVersion ; `
  };
# NOTE: this is to ignore the following error:
# ⛬ ❯ Import-Module: Failed to import function : Could not find a part of the path '/usr/lib/powershell/ref
# hadolint ignore=DL3059
RUN Import-Module VMware.PowerCLI -ErrorAction SilentlyContinue || & { $global:LASTEXITCODE = 0 }
# hadolint ignore=DL3059
RUN Get-PowerCLIVersion
# ────────────────────────────────────────────────────────────────────────────────
ENTRYPOINT [ "/usr/bin/pwsh" ,"-NoLogo","-NoProfile","-Command"]
