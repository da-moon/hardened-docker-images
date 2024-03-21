# syntax = docker/dockerfile:labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────
# hadolint ignore=DL3007
FROM cgr.dev/chainguard/python:latest

SHELL ["/usr/bin/python","-c"]

ENV USER="nonroot"
USER "${USER}"

ENV HOME="/home/${USER}"
ENV PATH="${PATH}:${HOME}/.local/bin"
# hadolint ignore=SC1071
RUN \
import urllib.request ; \
import os ; \
# NOTE Download the script
url = "https://bootstrap.pypa.io/get-pip.py" ; \
file_name = "{}/get-pip.py".format(os.environ['HOME']) ; \
response = urllib.request.urlopen(url); \
file = open(file_name, 'wb'); \
file.write(response.read()); \
file.close(); \
# NOTE: Run the script
file = open(file_name, 'r', encoding='utf-8'); \
code = compile(file.read(), file_name, 'exec'); \
file.close(); \
os.remove(file_name); \
# NOTE: get-pip script exits so we cannot have another instruction after
# running the `get-pip` script
exec(code) ;

ARG CHECKOV_VERSION="3.2.43"
# NOTE: installation and cleanup of pip packages
# https://stackoverflow.com/a/15950647
# hadolint ignore=SC1071
RUN \
import os ; \
import pip; \
# NOTE: install pip packages
package_to_install=['checkov>={}'.format(os.environ['CHECKOV_VERSION'])] ; \
pip.main(['install'] + package_to_install + ['--no-cache-dir']) ; \
# NOTE: cleanup
package_to_remove=['pip' ,'setuptools' ,'wheel'] ; \
pip.main(['uninstall'] + package_to_remove + ['--yes']) ;

ENTRYPOINT [ "checkov" ]
