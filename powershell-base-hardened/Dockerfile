# syntax = docker/dockerfile:labs
# escape=`
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────

# hadolint ignore=DL3007
FROM "cgr.dev/chainguard/curl:latest" AS powershell-core-modules-downloader
WORKDIR "/home/curl"
ARG POWERSHELL_VERSION="7.0.0"
ENV POWERSHELL_VERSION "${POWERSHELL_VERSION}"
# NOTE: we have to set our shell to curl as this base image does not have a shell
SHELL ["/usr/bin/curl","-fsSL", "--output", "powershell-linux-x64.tar.gz" , "--variable" , "%POWERSHELL_VERSION","--expand-url"]
# NOTE: do not wrap the following line in double quates as it makes the build fail
RUN https://github.com/PowerShell/PowerShell/releases/download/v{{POWERSHELL_VERSION}}/powershell-{{POWERSHELL_VERSION}}-linux-x64.tar.gz
# ────────────────────────────────────────────────────────────────────────────────
# hadolint ignore=DL3007
FROM "cgr.dev/chainguard/busybox:latest" AS powershell-core-modules-extractor
ENV USER="nonroot"
ENV HOME="/home/${USER}"
WORKDIR "/home/${USER}"
COPY --chmod="755" --chown="${USER}:${USER}" --from=powershell-core-modules-downloader "/home/curl/powershell-linux-x64.tar.gz" "${HOME}/powershell-linux-x64.tar.gz"
RUN tar -xzf "powershell-linux-x64.tar.gz" "./Modules" "./ref" && rm "powershell-linux-x64.tar.gz"
# ────────────────────────────────────────────────────────────────────────────────
# hadolint ignore=DL3007
FROM cgr.dev/chainguard/powershell:latest
SHELL [ "/usr/bin/pwsh" ,"-NoLogo","-NoProfile","-Command"]
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV USER="nonroot"
ENV HOME="/home/${USER}"
ENV PSModulePath="${HOME}/.local/share/powershell/core/modules"
COPY --chmod="755" --chown="${USER}:${USER}"  --from=powershell-core-modules-extractor "${HOME}/Modules" "${HOME}/.local/share/powershell/core/modules"
COPY --chmod="755" --chown="root:root"  --from=powershell-core-modules-extractor "${HOME}/ref" "/usr/lib/powershell/ref"
WORKDIR "${HOME}"
ENV POWERSHELL_TELEMETRY_OPTOUT="1"
ENV ErrorActionPreference="Stop"
ENV ProgressPreference="SilentlyContinue"
RUN `
$ErrorActionPreference = "$Env:ErrorActionPreference" ; `
$ProgressPreference = "$Env:ProgressPreference" ; `
Import-Module "PowerShellGet"; `
Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted";
# ────────────────────────────────────────────────────────────────────────────────
ENTRYPOINT [ "/usr/bin/pwsh" ,"-NoLogo","-NoProfile","-Command"]
